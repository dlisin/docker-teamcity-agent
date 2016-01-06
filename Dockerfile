FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get update \
 && apt-get install -yq \
 			build-essential \
 			software-properties-common \
 			unzip \
 			wget \
 && apt-add-repository ppa:webupd8team/java \
 && apt-add-repository ppa:ansible/ansible \
 && apt-get update \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && apt-get install -yq \
 			git \
 			oracle-java8-installer \
 			ansible \
 && apt-get clean


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


# Install TeamCity Build Agent
ENV GIT_USER_NAME "teamcity"
ENV GIT_USER_EMAIL "teamcity@jetbrains.com"
ENV TEAMCITY_AGENT_NAME ""
ENV TEAMCITY_AGENT_PORT 9090
ENV TEAMCITY_SERVER "http://localhost:8111"

RUN useradd -m teamcity

ADD teamcity-agent.sh /home/teamcity/teamcity-agent.sh
RUN chown teamcity:teamcity /home/teamcity/teamcity-agent.sh


USER teamcity

EXPOSE $TEAMCITY_AGENT_PORT
CMD ["/home/teamcity/teamcity-agent.sh"]
