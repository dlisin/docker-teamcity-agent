# docker-teamcity-agent

Docker container for [TeamCity](https://www.jetbrains.com/teamcity/) build agent

## Usage

### Build

```
docker build -t dlisin/teamcity-agent .
```

### Run

#### Configuration

##### Environment variables

 - `TEAMCITY_SERVER` (default: `http://localhost:8111/`): The address of the TeamCity server. The same as is used to open TeamCity web interface in the browser.
 - `TEAMCITY_AGENT_NAME`: The unique name of the agent used to identify this agent on the TeamCity server.
 - `TEAMCITY_AGENT_PORT` (default: `9090`): A port that TeamCity server will use to connect to the agent.

#### Prerequisites

A TeamCity server should be up and running to be able to download the `buildAgent` zip file.

```
docker run -d --name teamcity-agent \
-e TEAMCITY_SERVER=http://localhost:8111 -e TEAMCITY_AGENT_NAME=build-agent dlisin/teamcity-agent
```

The bootstrap script will automatically download (from the TeamCity server) and start a build agent.

#### Maven repository

The Maven repository should be created in `/root/.m2/repository`. This directory can be shared between severals agents container with a [data container](https://docs.docker.com/engine/userguide/dockervolumes/)

Example: 

```
docker run -d --name maven-repository -v /root/.m2/repository busybox

docker run -d --name teamcity-agent --link teamcity:teamcity \ 
-e TEAMCITY_URL=http://teamcity:8111 -e AGENT_NAME=agent-1 \ 
--volumes-from maven-repository herau/teamcity-agent

docker run -d --name teamcity-agent --link teamcity:teamcity \ 
-e TEAMCITY_URL=http://teamcity:8111 -e AGENT_NAME=agent-2 \ 
--volumes-from maven-repository herau/teamcity-agent
```
