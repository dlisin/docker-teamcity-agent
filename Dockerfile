FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get update \
 && apt-get install -yq wget unzip git build-essential software-properties-common \
 && apt-get clean


# Install Oracle JDK 8
RUN apt-add-repository ppa:webupd8team/java \
 && apt-get update \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && apt-get install -yq oracle-java8-installer \
 && apt-get clean \
 && java -version


# Install Ansible
RUN apt-add-repository ppa:ansible/ansible \
 && apt-get update \
 && apt-get install -yq ansible \
 && apt-get clean \
 && ansible --version


# Install Google Protobuf v2.6.1
RUN mkdir -p /opt/protobuf \
 && wget https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz \
 && tar -C /opt/protobuf -xzf protobuf-2.6.1.tar.gz \
 && rm protobuf-2.6.1.tar.gz \
 && cd /opt/protobuf/protobuf-2.6.1 \
 && ./configure \
 && make \
 && make check \
 && make install \
 && ldconfig \
 && protoc --version


# Install Perforce Client v2015.2
ENV P4_HOME=/opt/perforce
ENV PATH=$P4_HOME:$PATH

RUN mkdir -p /opt/perforce \
 && wget -P /opt/perforce http://cdist2.perforce.com/perforce/r15.2/bin.linux26x86_64/p4 \
 && chmod a+x /opt/perforce/p4 \
 && p4 -V

# Install TeamCity Build Agent
ENV TEAMCITY_AGENT_NAME ""
ENV TEAMCITY_AGENT_PORT 9090
ENV TEAMCITY_SERVER "http://localhost:8111"

RUN useradd -m teamcity

ADD teamcity-agent.sh /home/teamcity/teamcity-agent.sh
RUN chown teamcity:teamcity /home/teamcity/teamcity-agent.sh

USER teamcity

EXPOSE $TEAMCITY_AGENT_PORT
CMD ["/home/teamcity/teamcity-agent.sh"]
