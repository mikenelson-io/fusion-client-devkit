# How to run
# 1. Create a directory and name it <CLIENT_NAME_DIR>
# 2. Copy your private key to <CLIENT_NAME_DIR> with the name: private-key.pem
# 3. Create one-line file with issuer-id in it. Name it issuer and put it to directory <CLIENT_NAME_DIR>
# 4. For accesing swagger you need to expose port 8080 in your container with: -p <YOUR_PORT>:8080 flag
# 5. Now you can run the container with this command:
#
# In detached mode:
# docker run -p <YOUR_PORT>:8080 -v <FULL_PATH_CLIENT_NAME_DIR>/:/<CLIENT_NAME>-client/ -dit <IMAGE_NAME>
# In interactive session:
# docker run -p <YOUR_PORT>:8080 -v <FULL_PATH_CLIENT_NAME_DIR>/:/<CLIENT_NAME>-client/ -it --rm <IMAGE_NAME>
#
# You are ready to go!
# To use python script: docker exec <CONTAINER_ID> python3 samples/python/<PATH_TO_SCRIPT>
# To use ansible playbook: docker exec <CONTAINER_ID> ansible-playbook samples/ansible/<PATH_TO_PLAYBOOK>
# To use hmctl: docker exec <CONTAINER_ID> hmctl <COMMAND>
# You can also enter interactive session: docker exec -it <CONTAINER_ID> /bin/bash

ARG TARGETPLATFORM
ARG LOCAL_REGISTRY=localhost:5000/
ARG SWAGGER_UI_IMAGE=swagger-ui:v4.15.5

FROM ${LOCAL_REGISTRY}${SWAGGER_UI_IMAGE}

# Install required tools
RUN apk update && apk add --no-cache wget git\
    py3-pip python3-dev\
    bash bash-completion\
    gcc musl-dev libffi-dev openssh
RUN apk add terraform --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community

# Install Python SDK and Ansible
RUN pip3 install wheel
RUN pip3 install purefusion cryptography==3.4.8 ansible netaddr

# Install ansible's fusion collection
RUN ansible-galaxy collection install purestorage.fusion

COPY patches/modules/ /root/.ansible/collections/ansible_collections/purestorage/fusion/plugins/modules/
COPY patches/module_utils/ /root/.ansible/collections/ansible_collections/purestorage/fusion/plugins/module_utils/

# Get ansible playbooks, terraform plans, and python scripts
COPY ansible  ./samples/ansible
COPY python  ./samples/python
COPY terraform ./samples/terraform

# Install hmctl 
RUN if [ ${TARGETPLATFORM} == "linux/arm64" ] ; then wget -O /bin/hmctl https://github.com/PureStorage-OpenConnect/hmctl/releases/latest/download/hmctl-linux-arm64 ; else wget -O /bin/hmctl https://github.com/PureStorage-OpenConnect/hmctl/releases/latest/download/hmctl-linux-amd64 ; fi
RUN chmod +x /bin/hmctl &&\
    mkdir /etc/bash_completion.d &&\
    hmctl completion bash > /etc/bash_completion.d/hmctl

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

# Modify MOTD
ENV INSTALL /usr/local/src
RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo "\
██████  ██    ██ ██████  ███████ ███████ ████████  ██████  ██████   █████   ██████  ███████ \n\
██   ██ ██    ██ ██   ██ ██      ██         ██    ██    ██ ██   ██ ██   ██ ██       ██      \n\
██████  ██    ██ ██████  █████   ███████    ██    ██    ██ ██████  ███████ ██   ███ █████   \n\
██      ██    ██ ██   ██ ██           ██    ██    ██    ██ ██   ██ ██   ██ ██    ██ ██      \n\
██       ██████  ██   ██ ███████ ███████    ██     ██████  ██   ██ ██   ██  ██████  ███████ \n\
\n\
Welcome to the Pure Fusion DevKit. Here is some information to get you started: \n\
- Generic sample scripts are located in the /samples folder. Do not use these as-is. You must modify them to suit your environment. \n\
- If you enabled the -p port option when launching this container, the Fusion Swagger interface can be accessed at http://localhost:port/ \n\
- Refer to the documentation in the GitHub repository and the purestorage.com website for more information. \n\
- If you have any questions, please contact Pure Storage Support. \n\
\n\
\n"\
    > /etc/motd

# Add bash entrypoint
CMD ["bash"]
