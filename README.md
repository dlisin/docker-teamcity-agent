### TeamCity Build Agent
[TeamCity Build Agent](https://www.jetbrains.com/teamcity/) image with a number of preinstalled build tools:
 - [Ansible](http://www.ansible.com/)
 - [Git](https://git-scm.com/)
 - [Google Protobuf](https://developers.google.com/protocol-buffers/)
 - [Oracle JDK](http://www.oracle.com/technetwork/java/)

### Run

#### Prerequisites
A TeamCity server should be up and running to be able to download the `buildAgent` zip file.

#### Environment variables
 - `GIT_USER_NAME`: Git user name. Default value: `teamcity`
 - `GIT_USER_EMAIL`: Git user email address. Default value: `teamcity@jetbrains.com`
 - `TEAMCITY_SERVER`: The address of the TeamCity server. Default value: `http://localhost:8111/`
 - `TEAMCITY_AGENT_NAME`: The unique name of the agent used to identify this agent on the TeamCity server.
 - `TEAMCITY_AGENT_PORT`: A port that TeamCity server will use to connect to the agent. Default value: `9090`

#### Usage
Pull the image, create a new container and start it:
```
docker pull dlisin/teamcity-agent
docker create --restart=always  --name build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=build-agent \
   -d dlisin/teamcity-agent
docker start build-agent
```
The bootstrap script will automatically download (from the TeamCity server) and start a build agent.

### Build
```
docker build -t dlisin/teamcity-agent .
```
