FROM java:8

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get clean \
 && apt-get update \
 && apt-get install -yq git build-essential \
 && apt-get clean


# Install Google Protobuf
ENV PROTOBUF_VERSION 2.6.1
RUN wget https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-$PROTOBUF_VERSION.tar.gz \
 && tar -xzf protobuf-$PROTOBUF_VERSION.tar.gz \
 && rm protobuf-$PROTOBUF_VERSION.tar.gz \
 && cd protobuf-$PROTOBUF_VERSION \
 && ./configure \
 && make \
 && make check \
 && make install \
 && ldconfig \
 && protoc --version \
 && cd .. \
 && rm -rf protobuf-$PROTOBUF_VERSION


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
