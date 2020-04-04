#inspired by https://github.com/retog/docker-x11-xpra
#inspired by https://hub.docker.com/r/enricomariam42/x11-xpra

FROM ubuntu:18.04
# Expose the SSH port
EXPOSE 22

RUN apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server \
    x11-apps xterm language-pack-en-base language-pack-de-base \
    xserver-xephyr blackbox xpra joe apt-transport-https ca-certificates \
    software-properties-common apt-utils

RUN apt-add-repository ppa:vantuz/cool-retro-term && \
    apt-get update && apt-get -y install cool-retro-term

# Fix locale issue, see https://github.com/phusion/baseimage-docker/issues/276
RUN locale-gen de_DE.UTF-8
ENV LANG=de_DE.UTF-8 \
    LANGUAGE=de:en \
    LC_ALL=de_DE.UTF-8
    
# Add user "user"
RUN adduser --disabled-password --gecos "User" --uid 1000 user

ENV TERM=xterm \
    DISPLAY=:100

ADD xpra-display /tmp/xpra-display
RUN echo "$(cat /tmp/xpra-display)\n$(cat /etc/bash.bashrc)" > /etc/bash.bashrc 

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd 

# Disable tunnelled clear text passwords
RUN sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config \
    && sed -i 's/#UsePAM/UsePAM/' /etc/ssh/sshd_config \
    && sed -i '/PasswordAuthentication/s/yes/no/g' /etc/ssh/sshd_config \
    && sed -i '/UsePAM/s/yes/no/g' /etc/ssh/sshd_config
    
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /home/user

#inspired by https://hub.docker.com/r/jamesnetherton/docker-atom-editor/dockerfile
#inspired by https://atom.io/releases
#atom
RUN wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list' && \
    apt-get update && apt-get -y install atom
    
#CMD /usr/sbin/sshd -D
# Start SSH anx Xpra
#CMD mkdir -p /home/user/.ssh/ && chown -R user:user /home/user \ 
CMD /usr/sbin/sshd && rm -f /tmp/.X100-lock \ 
    && su user -c "xpra start $DISPLAY && sleep 1 && cp ~/.xpra/run-xpra /tmp/run-xpra \
    && cat /tmp/run-xpra | grep -v affinity > ~/.xpra/run-xpra && sleep infinity"