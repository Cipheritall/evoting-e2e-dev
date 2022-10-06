# Deploy passwords
To be able to do the initial import of the keys into the database, the keys must first be manually deployed on the running services.
Once the service is running and the war finished deploying, run the following from the tools folder:

```./copyPasswords.bash authentication```

For a complete successsful import of the keys, this script has to be run for the currently 8 available services:
* authentication
* certificate-registry
* election-information
* extended-authentication
* orchestrator
* vote-verification
* voter-material
* voting-workflow

# Generate rabbitmq server certificate
We use [tls-gen](https://github.com/michaelklishin/tls-gen) as suggested in the RabbitMQ documentation, to generate a root CA certificate and self-signed certificate for the RabbitMQ server. To regenerate the certificate run:
`./generate_rabbitmq_certs.sh`