FROM java:8

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>


RUN apt-get update \
 && apt-get install -yq git \
 && apt-get clean


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
