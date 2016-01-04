#!/usr/bin/env bash

AGENT_DIR="${HOME}/agent"

if [ ! -d "$AGENT_DIR" ]; then
    echo "Setting up TeamCity agent for the first time..."
    echo "Agent will be installed to ${AGENT_DIR}."

    cd $HOME \
    && wget $TEAMCITY_SERVER/update/buildAgent.zip \
    && mkdir -p $AGENT_DIR \
    && unzip -q -d $AGENT_DIR buildAgent.zip \
    && rm buildAgent.zip \
    && cd $AGENT_DIR \
    && cp conf/buildAgent{.dist,}.properties \
    && sed -i 's#^\(serverUrl=\).*$#\1'$TEAMCITY_SERVER'#' conf/buildAgent.properties \
    && sed -i 's#^\(name=\).*$#\1'$TEAMCITY_AGENT_NAME'#' conf/buildAgent.properties \
    && sed -i 's#^\(ownPort=\).*$#\1'$TEAMCITY_AGENT_PORT'#' conf/buildAgent.properties \
    && chmod +x $AGENT_DIR/bin/agent.sh
fi

echo "Using agent at ${AGENT_DIR}."
$AGENT_DIR/bin/agent.sh run