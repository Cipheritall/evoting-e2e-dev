# How to start all services locally on a Post laptop (16GB RAM)
## Prerequisites
You need Docker to have sufficient memory allocated. This was tested with 9gb RAM assigned to the docker enginer, 4gb swap space and 10 cpus. If the docker engine dies (generally experienced as unable to connect to it anymore) that's probably because your host killed some Docker processes because the host was running out of memory. To avoid that quit other applications running, eg Skype, browser, outlook, chatit, etc and then restart the Docker engine. 

## Adjusting memory limit
Some components may become unresponsive and thus unhealthy which could be caused by running out of memory. This can generally be seen in the logs for JVMs by repeated "GC Allocation Error", or some service running with 100% CPU for some time (due to swapping). In this case we should increase the memory limit for that service. However we should always be careful not to go over the memory allocated to Docker otherwise the host might kill the Docker engine. 
Memory can be increase by allocation more RAM or more swap. 

##Creating a database snapshot
To avoid having to wait a long time each time for the database to start, you should create a snapshot of the database once it has started and is ready. To do that:
1. Start the normal database through docker compose with: `docker-compose up --force-recreate database`
2. Run the script `create-db-snapshot.sh` in scripts/local-deploy
3. Stop the database: `docker-compose stop database`
4. Change the image to build from in the docker-compose to `image: ev/database-snap:0.11.0` 

## Start and stop
### With optimized database startup time
Start: 
1. `docker-compose up -d --force-recreate`
2. Launch the SDM frontend by following the instructions in sdm-frontend/Readme.md

Note: some components are first marked as unhealthy before becoming healthy. If after 5 minutes all components are not healthy then something went wrong. 

Stop: `docker-compose stop`

### Without optimized database startup time
Start:
1. `cd scripts/local-deploy`
2. `./start-first.sh`
3. Wait for the db to be healthy (as per `docker ps`). Note that it is possible for the db to be unhealthy for a little bit before appearing healthy. It normally takes between 10-15 mn for the db to be healthy.
4. `./start-backend.sh`
5. Wait for all backend services to be healthy. 
6. `./start-control-components.sh`
7. Wait for all control-components to be healthy
8. Launch the SDM executing the executable in sdm-frontend/win64/Secure Data Manager.exe

Stop:
There are scripts names `stop-<>.sh` to stop the appropriate services.  

