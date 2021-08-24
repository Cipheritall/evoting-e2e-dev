# Prerequisites

These instructions will allow you to test the E-Voting solution in a local development environment. The possibility of running end-to-end tests shall provide researchers with a better understanding of the cryptographic protocol and facilitate public scrutiny. The **development** environment does **not** represent Swiss Post's [productive environment](https://gitlab.com/swisspost-evoting/e-voting/e-voting-documentation/-/blob/master/Operations/Infrastructure%20whitepaper%20of%20the%20Swiss%20Post%20voting%20system.md) and omits numerous security elements such as HTTP security headers, separate network zones, and a web application firewall.

## Compile the E-Voting solution

Set up the build environment and build the E-Voting solution: [see README.md](https://gitlab.com/swisspost-evoting/e-voting/e-voting)

## Install Docker

Follow the instructions here: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

## Memory Requirements

Beware that running the entire E-voting system (comprising multiple components) on a single machine is very memory intensive.
We recommend configuring Docker with at least 15 GB RAM.

## Prepare Environment Variables

Create the following system environment variable (adapt them to the correct location):

| Name     | Version    |
| --------|---------|
| **EVOTING_DOCKER_HOME**  | C:\work\projects\evoting-e2e-dev (it should point to the directory where this repository was cloned)    |
| **DOCKER_REGISTRY**  | registry.gitlab.com/swisspost-evoting/e-voting/evoting-e2e-dev

## Build & start the Docker Images

To build and start the docker images, run the following script

```sh
./prepare-e2e.sh
```

Alternatively, you can run the following commands:

```sh
docker-compose -f docker-compose.common.yml -f docker-compose.h2.yml build
docker-compose -f docker-compose.common.yml -f docker-compose.h2.yml stop
docker-compose -f docker-compose.common.yml -f docker-compose.h2.yml up -d --force-recreate
```

## Known Issues

The current version of the development end-2-end has the following issues in the Secure Data Manager GUI:

- **PRE-COMPUTE:** When selecting all Voting Card Sets at once to run the pre-compute step, a bug prevents some Voting Card Sets to move to the *PRE_COMPUTED* tab. As a workaround, launch the process for one Voting Card Set at a time.
- **COMPUTE:** When selecting all Voting Card Sets at once to run the compute step, a bug prevents the process from starting correctly. As a workaround, launch the process for one Voting Card Set at a time.

## Run an Election Event

Follow [Run_Election_Event.md](./Run_Election_Event.md)
