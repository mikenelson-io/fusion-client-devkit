# How to run
# 1. Create a directory and name it <CLIENT_NAME_DIR>
# 2. Copy your private key to <CLIENT_NAME_DIR> with the name: private-key.pem
# 3. Create one-line file with issuer-id in it. Name it "issuer" with no extension and put it to directory <CLIENT_NAME_DIR>
# 4. For accesing the Swagger interface, you will need to expose port 8080 in your container with: -p <YOUR_PORT>:8080 flag
# 5. Now, you can run the container with this command:
#
# In non-interactive mode with Swagger:
# docker run -p <YOUR_PORT>:8080 -v <FULL_PATH_CLIENT_NAME_DIR>/:/<CLIENT_NAME>-client/ -dit <IMAGE_NAME>
# In interactive mode with Swagger:
# docker run -p <YOUR_PORT>:8080 -v <FULL_PATH_CLIENT_NAME_DIR>/:/<CLIENT_NAME>-client/ -it --rm <IMAGE_NAME>
#
# To execue a pre-configured python example script when starting the container: docker exec <CONTAINER_ID> python3 samples/python/<PATH_TO_SCRIPT>
# To execute a pre-configured ansible playbook example when starting the container: docker exec <CONTAINER_ID> ansible-playbook samples/ansible/<PATH_TO_PLAYBOOK>
# To execute a pfctl command when starting the container: docker exec <CONTAINER_ID> pfctl <COMMAND>
# You can also enter an interactive session to the bash prompt: docker exec -it <CONTAINER_ID> /bin/bash

ARG ANSIBLE_PLAYBOOKS_COMMIT=15b267064f095ba737eb23eb7be3bb4c67efa082

FROM swaggerapi/swagger-ui:v5.1.0

# Install required tools
RUN apk update && apk add --no-cache wget git\
    py3-pip bash bash-completion openssh terraform

# Install tools for arm64
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then apk add --no-cache python3-dev libffi-dev gcc musl-dev; fi

# Clear cache
RUN rm -rf /var/cache/apk/*

# Install Python SDK and Ansible 
RUN pip3 install cryptography ansible netaddr
RUN pip3 install 'purefusion>=1.2.0,<2.0.0'

# Install ansible's fusion collection
RUN ansible-galaxy collection install 'purestorage.fusion:>=1.6.0,<2.0.0'

# Get ansible playbooks, terraform plans, and python scripts
COPY python  ./samples/python
COPY terraform ./samples/terraform
RUN git clone https://github.com/PureStorage-OpenConnect/ansible-playbook-examples.git ./ansible-playbook-examples &&\
    cd ./ansible-playbook-examples &&\
    git reset --hard $ANSIBLE_PLAYBOOKS_COMMIT &&\
    cd ..  &&\
    mv ./ansible-playbook-examples/fusion ./samples/ansible &&\
    rm -rf ./ansible-playbook-examples

# Install pfctl 
RUN curl https://api.github.com/repos/PureStorage-OpenConnect/pfctl/releases > releases.json
RUN export PFCTL_VERSION=$(grep -m 1 '"tag_name": "v1' releases.json | awk -F'"' '{print $4}') &&\
    if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
    wget -O ./pfctl.tar.gz https://github.com/PureStorage-OpenConnect/pfctl/releases/download/$PFCTL_VERSION/pfctl-linux-arm64.tar.gz; \
    else \
    wget -O ./pfctl.tar.gz https://github.com/PureStorage-OpenConnect/pfctl/releases/download/$PFCTL_VERSION/pfctl-linux-amd64.tar.gz; \
    fi
RUN tar -xf pfctl.tar.gz -C /bin &&\
    chmod +x /bin/pfctl &&\
    mkdir /etc/bash_completion.d &&\
    pfctl completion bash > /etc/bash_completion.d/pfctl &&\
    rm releases.json &&\
    rm pfctl.tar.gz

# Swagger settings
ENV SWAGGER_JSON=/generated_spec.yaml
COPY ./generated/generated_spec.yaml /generated_spec.yaml

# Add entrypoint
COPY docker-entrypoint/50-fusion.sh /docker-entrypoint.d/50-fusion.sh
RUN chmod +x /docker-entrypoint.d/50-fusion.sh &&\
    echo "$(cat /docker-entrypoint.d/50-fusion.sh)" > /etc/profile.d/bashrc.sh

# Change docker-entrypoint.sh 
ENV NGINX_ENTRYPOINT_QUIET_LOGS=1
RUN mv /docker-entrypoint.sh /nginx-entrypoint.sh 
COPY docker-entrypoint/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

LABEL maintainer="purestorage"

# Add bash entrypoint
CMD ["bash"]
