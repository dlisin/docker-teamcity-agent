FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>

ENV ANSIBLE_VERSION=1.9.4
ENV GRADLE_VERSION=2.14.1

RUN apt-get update \
 && apt-get install -yq \
            software-properties-common \
            build-essential \
            libffi-dev \
            python-dev python-pip python-yaml python-jinja2 python-httplib2 python-paramiko python-pkg-resources \
            curl \
            unzip \
            wget \
 && apt-add-repository ppa:webupd8team/java \
 && apt-add-repository ppa:ubuntu-lxc/lxd-stable \
 && add-apt-repository ppa:cwchien/gradle \
 && curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - \
 && apt-get update \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && pip install ansible==${ANSIBLE_VERSION} \
 && apt-get install -yq \
            git \
            gradle-${GRADLE_VERSION} \
            nodejs \
            oracle-java8-installer \
            protobuf-compiler \
            uuid-runtime \
 && apt-get clean

# Set env. variables
ENV GRADLE_HOME=/usr/lib/gradle/${GRADLE_VERSION}/

# Install TeamCity Build Agent
ENV TEAMCITY_AGENT_NAME ""
ENV TEAMCITY_AGENT_PORT 9090
ENV TEAMCITY_SERVER "http://localhost:8111"

ADD teamcity-agent.sh teamcity-agent.sh

EXPOSE $TEAMCITY_AGENT_PORT
CMD ["./teamcity-agent.sh"]
