#Commands

##Build
`docker build -t ev/message-broker:${EVOTING_VERSION} .`

##Run
`docker run --name message-broker  -p 5672:5672 ev/message-broker:${EVOTING_VERSION}`

# RabbitMQ passwords
The password for a user is the name of that user. 

To generate rabbitmq hash passwords for the rabbit.definitions configuration (https://www.rabbitmq.com/passwords.html#computing-password-hash) run:

`python3 generate_rabbit_password_hash.py control-component1 control-component2 control-component3 control-component4`
