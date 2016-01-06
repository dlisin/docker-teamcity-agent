FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get update \
 && apt-get install -yq wget git build-essential \
 && apt-get clean


# Install Oracle JDK 8u66
ENV JAVA_HOME=/opt/jdk1.8.0_66
ENV PATH=$JAVA_HOME/bin:$PATH

RUN wget --header="Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz \
 && tar -C /opt -xzf  jdk-8u66-linux-x64.tar.gz \
 && rm jdk-8u66-linux-x64.tar.gz \
 && java -version


# Install Google Protobuf 2.6.1
RUN wget https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz \
 && tar -C /opt -xzf protobuf-2.6.1.tar.gz \
 && rm protobuf-2.6.1.tar.gz \
 && cd /opt/protobuf-2.6.1 \
 && ./configure \
 && make \
 && make check \
 && make install \
 && ldconfig \
 && protoc --version
 

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
