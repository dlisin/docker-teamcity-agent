[TeamCity Build Agent](https://www.jetbrains.com/teamcity/) image with a number of preinstalled build tools:
 - Git
 - [Google Protobuf v2.6.1](https://developers.google.com/protocol-buffers/)
 - [Oracle JDK v1.8u66](http://www.oracle.com/technetwork/java/javase/overview/index.html)


### Build
```
docker build -t dlisin/teamcity-agent .
```

### Run

#### Configuration

##### Environment variables
 - `TEAMCITY_SERVER`: The address of the TeamCity server. Default value: `http://localhost:8111/`
 - `TEAMCITY_AGENT_NAME`: The unique name of the agent used to identify this agent on the TeamCity server.
 - `TEAMCITY_AGENT_PORT`: A port that TeamCity server will use to connect to the agent. Default value: `9090`

#### Prerequisites
A TeamCity server should be up and running to be able to download the `buildAgent` zip file.
```
docker run -d --name teamcity-agent \
    -e TEAMCITY_SERVER=http://localhost:8111 
    -e TEAMCITY_AGENT_NAME=build-agent \
  dlisin/teamcity-agent
```
The bootstrap script will automatically download (from the TeamCity server) and start a build agent.
