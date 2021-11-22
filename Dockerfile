FROM xxor/buster-builder:1.0

RUN apt update -y  --allow-releaseinfo-change && \
    apt install apt-utils gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping locales -y

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN echo en_US UTF-8 >> /etc/locale.gen
RUN apt-get install -y locales && locale-gen && dpkg-reconfigure --frontend=noninteractive locales && \
update-locale LANG=$LANG

RUN mkdir /home/yocto
RUN useradd -ms /bin/bash user

RUN chown user:user /home/yocto

RUN mkdir /home/user/.ssh
COPY id_rsa /home/user/.ssh/id_rsa
RUN chmod 600 /home/user/.ssh/id_rsa && \
    chown -R user:user /home/user/.ssh && \
    eval "$(ssh-agent -s)" && \
    ssh-add /home/user/.ssh/id_rsa && \
    ssh-keyscan -H github.com >> /home/user/.ssh/known_hosts

USER user

WORKDIR /home/yocto
