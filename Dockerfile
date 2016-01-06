FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get update \
 && apt-get install -yq wget git build-essential \
 && apt-get clean


# Install Oracle JDK v1.8u66
ENV JAVA_HOME=/opt/jdk/jdk1.8.0_66
ENV PATH=$JAVA_HOME/bin:$PATH

RUN mkdir -p /opt/jdk \ 
 && wget --header="Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz \
 && tar -C /opt/jdk -xzf  jdk-8u66-linux-x64.tar.gz \
 && rm jdk-8u66-linux-x64.tar.gz \
 && java -version


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
