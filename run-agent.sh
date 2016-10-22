#!/usr/bin/env bash

TEAMCITY_AGENT_HOME="${HOME}/agent"

if [ ! -d "$TEAMCITY_AGENT_HOME" ]; then
    echo "Setting up TeamCity agent for the first time..."
    echo "Agent will be installed to ${TEAMCITY_AGENT_HOME}."
    cd $HOME \
    && wget $TEAMCITY_SERVER/update/buildAgent.zip \
    && mkdir -p $TEAMCITY_AGENT_HOME \
    && unzip -q -d $TEAMCITY_AGENT_HOME buildAgent.zip \
    && rm buildAgent.zip \
    && cd $TEAMCITY_AGENT_HOME \
    && cp conf/buildAgent{.dist,}.properties \
    && sed -i 's#^\(serverUrl=\).*$#\1'$TEAMCITY_SERVER'#' conf/buildAgent.properties \
    && sed -i 's#^\(name=\).*$#\1'$TEAMCITY_AGENT_NAME'#' conf/buildAgent.properties \
    && sed -i 's#^\(ownPort=\).*$#\1'$TEAMCITY_AGENT_PORT'#' conf/buildAgent.properties \
    && chmod +x $TEAMCITY_AGENT_HOME/bin/agent.sh
fi

echo "Using agent at ${TEAMCITY_AGENT_HOME}."
$TEAMCITY_AGENT_HOME/bin/agent.sh run