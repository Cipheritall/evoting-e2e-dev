# Introduction

These instructions will allow you to test the e-voting system in a local development environment. The possibility of running end-to-end tests shall
provide researchers with a better understanding of the cryptographic protocol and facilitate public scrutiny. The **development** environment does **
not** represent Swiss
Post's [productive environment](https://gitlab.com/swisspost-evoting/e-voting/e-voting-documentation/-/blob/master/Operations/Infrastructure%20whitepaper%20of%20the%20Swiss%20Post%20voting%20system.md)
and omits numerous security elements such as HTTP security headers, separate network zones, and a web application firewall.

## Prerequisites

- **Windows**  

  The e-voting end-to-end environment requires to be run from a Windows machine since the Secure Data Manager components are only available for Windows.
  <br>

- **Built e-voting system**  

  To set up a working e-voting end-to-end test, you need to build the e-voting system itself. For that please refer to
  the [building guide](https://gitlab.com/swisspost-evoting/e-voting/e-voting/-/blob/master/BUILDING.md) of e-voting.
  <br>

- **Folder structure**  

  Once you followed the [building guide](https://gitlab.com/swisspost-evoting/e-voting/e-voting/-/blob/master/BUILDING.md) of e-voting, you should have
  a folder with the following structure:

  ```
  <DIRECTORY>
  │   build.tar.gz (This archive is generated by the evoting-build Docker image)
  │   e2e.sh
  ```

  In the case you didn't use the provided Docker image, ensure to have the following folder structure:

  ```
  <DIRECTORY>
  │   e-voting/ (built)
  │   evoting-e2e-dev/
  │   e2e.sh (initially located in evoting-e2e-dev/scripts/)
  ```
  <br>

- **Install Docker**

  The e-voting end-to-end test environment requires Docker to deploy services in Docker containers. Therefore, you need to install Docker on the
  machine that will run the end-to-end.

  Follow the instructions here: [Install Docker Desktop on Windows](https://docs.docker.com/desktop/windows/install/)
  <br>

- **Have a Unix shell**

  To easily configure the e-voting end-to-end environment, various Linux commands are useful. Therefore you need to have a Unix shell available on the
  machine. You can, for example, use the [portable Git-bash](https://git-scm.com/download/win).
  <br>

- **Memory requirements**

  Beware that running the entire E-voting system (comprising multiple components) on a single machine is very memory intensive. We recommend configuring
  Docker with at least 30 GB RAM.
  <br>
  

## Build, configure and start all services

Once you fulfill all prerequisites, you can run the `e2e.sh` script in a Unix shell:

```sh
./e2e.sh
```

This script builds and deploys all services of the e-voting system. It also creates, in the folder containing the e2e.sh script, a
folder `secure-data-manager-<VERSION>` containing the multiple preconfigured Secure Data Manager instances.

Moreover, once the script has built and deployed all e-voting services, it starts to listen to the output logs of the Docker containers.

As soon as all services are healthy, you can go to the next section. To check if all services are healthy, you can inspect the result of the following
command:

```sh
docker ps
```

## Run an Election Event

In order to carry out an election event, please follow the [Run Election Event-Guide.](./Run_Election_Event.md)
