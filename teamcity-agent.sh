#!/usr/bin/env bash

TEAMCITY_AGENT_DIR="${HOME}/agent"

if [ ! -d "$TEAMCITY_AGENT_DIR" ]; then
    echo "Setting up TeamCity agent for the first time..."
    echo "Agent will be installed to ${TEAMCITY_AGENT_DIR}."
    cd $HOME \
    && wget $TEAMCITY_SERVER/update/buildAgent.zip \
    && mkdir -p $TEAMCITY_AGENT_DIR \
    && unzip -q -d $TEAMCITY_AGENT_DIR buildAgent.zip \
    && rm buildAgent.zip \
    && cd $TEAMCITY_AGENT_DIR \
    && cp conf/buildAgent{.dist,}.properties \
    && sed -i 's#^\(serverUrl=\).*$#\1'$TEAMCITY_SERVER'#' conf/buildAgent.properties \
    && sed -i 's#^\(name=\).*$#\1'$TEAMCITY_AGENT_NAME'#' conf/buildAgent.properties \
    && sed -i 's#^\(ownPort=\).*$#\1'$TEAMCITY_AGENT_PORT'#' conf/buildAgent.properties \
    && chmod +x $TEAMCITY_AGENT_DIR/bin/agent.sh

    echo "First-Time Git setup"
    git config --global user.name "&GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"

fi

echo "Using agent at ${TEAMCITY_AGENT_DIR}."
$TEAMCITY_AGENT_DIR/bin/agent.sh run