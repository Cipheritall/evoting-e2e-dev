# Prerequisites

🛑 **IMPORTANT: The publicly available end-2-end version works
with [E-Voting 0.12.0.0](https://gitlab.com/swisspost-evoting/e-voting/e-voting/-/tree/evoting-0.12.0.0) (commit-number: 9db6300e)**

These instructions will allow you to test the E-Voting solution in a local development environment. The possibility of running end-to-end tests shall
provide researchers with a better understanding of the cryptographic protocol and facilitate public scrutiny. The **development** environment does **not** represent Swiss
Post's [productive environment](https://gitlab.com/swisspost-evoting/e-voting/e-voting-documentation/-/blob/master/Operations/Infrastructure%20whitepaper%20of%20the%20Swiss%20Post%20voting%20system.md)
and omits numerous security elements such as HTTP security headers, separate network zones, and a web application firewall.

## Compile the E-Voting solution

Set up the build environment for the E-Voting solution version
0.12.0.0: [see README.md](https://gitlab.com/swisspost-evoting/e-voting/e-voting/-/blob/evoting-0.12.0.0/README.md).

Clone and build the following versions of the crypto-primitives libraries:

| Repositories                                                                                                                    | Version | 
|---------------------------------------------------------------------------------------------------------------------------------| ------- |
| [crypto-primitives](https://gitlab.com/swisspost-evoting/crypto-primitives/crypto-primitives/-/tree/crypto-primitives-0.12.0.0) | 0.12.0.0 | 
| [crypto-primitives-domain](https://gitlab.com/swisspost-evoting/crypto-primitives/crypto-primitives-domain/-/tree/crypto-primitives-domain-0.12.0.1)  | 0.12.0.1 |

Note that the E-Voting solution version 0.12.0.0 does not use crypto-primitives-ts.

Build the E-Voting solution version 0.12.0.0: [see README.md](https://gitlab.com/swisspost-evoting/e-voting/e-voting/-/tree/evoting-0.12.0.0#full-build).

## Install Docker

Follow the instructions here: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

## Memory Requirements

Beware that running the entire E-voting system (comprising multiple components) on a single machine is very memory intensive. We recommend configuring
Docker with at least 15 GB RAM.

## Prepare Environment Variables

Create the following system environment variable (adapt them to the correct location):

| Name     | Version    |
| --------|---------|
| **EVOTING_DOCKER_HOME**  | C:\work\projects\evoting-e2e-dev (it should point to the directory where this repository was cloned)    |
| **DOCKER_REGISTRY**  | registry.gitlab.com/swisspost-evoting/e-voting/evoting-e2e-dev |

## Build & start the Docker Images

To build and start the docker images, run the following script

```sh
./prepare-e2e.sh
```

Alternatively, you can run the following commands:

```sh
rm -rf testdata
cp -r testdata-external testdata
source copy-evoting-version-in-env-file.sh
docker-compose -f docker-compose.common.yml -f docker-compose.h2.yml build
docker-compose -f docker-compose.common.yml -f docker-compose.h2.yml stop
docker-compose -f docker-compose.common.yml -f docker-compose.h2.yml up -d --force-recreate
```

## Run an Election Event

Follow [Run_Election_Event.md](./Run_Election_Event.md)
