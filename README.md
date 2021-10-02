# Light Portal Hybrid Command Server

This is a light-hybrid-4j server for light portal command side services. All comamnd side portal 
services should be deployed on this server.


## Start server

If you only have one service jar file, then your can include the jar file into the
class path as below.

```
java -cp target/eventuate-command-1.4.6.jar com.networknt.server.Server
```

for windows:

```
java -cp target/eventuate-command-1.4.6.jar com.networknt.server.Server
```

If you have multiple service jar files, you'd better create a directory and include
that directory into the classpath when starting the server.

```
java -cp ./service/*:target/eventuate-command-1.4.6.jar com.networknt.server.Server
```

for windows:

```
java -cp ./service/*;target/eventuate-command-1.4.6.jar com.networknt.server.Server
```

## Test

## Docker
run docker-compose -f docker-compose-service.yml up from light-eventuate-4j root folder
  -- it will build and run the Dockerfile under command module
  
