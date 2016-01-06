FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get update \
 && apt-get install -yq \
 			software-properties-common \
 && apt-add-repository ppa:webupd8team/java \
 && apt-add-repository ppa:ansible/ansible \
 && apt-add-repository ppa:ubuntu-lxc/lxd-stable  \
 && apt-get update \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && apt-get install -yq \
 			ansible \
 			git \
 			oracle-java8-installer \
 			protobuf-compiler \
 			unzip \
 			wget \
 && apt-get clean


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
