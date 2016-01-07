### TeamCity Build Agent
[TeamCity Build Agent](https://www.jetbrains.com/teamcity/) image with a number of preinstalled build tools:
 - [Ansible](http://www.ansible.com/)
 - [Git](https://git-scm.com/)
 - [Google Protobuf](https://developers.google.com/protocol-buffers/)
 - [Oracle JDK](http://www.oracle.com/technetwork/java/)

### Usage

#### Prerequisites
A TeamCity server should be up and running to be able to download the `buildAgent` zip file.

#### Environment variables
 - `TEAMCITY_SERVER`: The address of the TeamCity server. Default value: `http://localhost:8111/`
 - `TEAMCITY_AGENT_NAME`: The unique name of the agent used to identify this agent on the TeamCity server.
 - `TEAMCITY_AGENT_PORT`: A port that TeamCity server will use to connect to the agent. Default value: `9090`

#### Run
Pull the image, create a new container and start it:
```
docker pull dlisin/teamcity-agent
docker create --restart=always --name build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=build-agent \
   dlisin/teamcity-agent
docker start build-agent
```
The bootstrap script will automatically download (from the TeamCity server) and start a build agent.

#### Upgrade
Pull updated image, stop and remove existing container, then create and start new container:
```
docker pull dlisin/teamcity-agent
docker stop build-agent
docker rm build-agent
docker create --restart=always --name build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=build-agent \
   dlisin/teamcity-agent
docker start build-agent   
```

#### .ssh and .gitconfig
Example how to mount `.ssh` folder and `.gitconfig` file to container:
```
docker pull dlisin/teamcity-agent
docker create --restart=always --name build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=build-agent \
   -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
   -v ~/.gitconfig:/root/.gitconfig \
   dlisin/teamcity-agent
docker start build-agent   
```
#### Start `bash` on running container
```
docker exec -i -t build-agent bash
```
#### View logs
```
docker logs build-agent
```

#### Build
```
docker build -t dlisin/teamcity-agent .
```

