# Run PAYLAY using Docker Compose
The easiest way to run PAYLAY is to download the following Docker Compose files:

- [installation.yml](installation.yml)
- [docker-compose.yml](docker-compose.yml)

Fire up a terminal or commandline and get started.

## 1. Run installation.yml
~~~
docker-compose -f installation.yml up
~~~

This instruction will create and start 2 containers: the IdentityServer and PaymentServer.

### 1.1 Database installation
Navigate to the IdentityServer endpoint `http://localhost:28890/installation`, follow the instructions to install the database and create initial operational data.

One of the final instructions is to copy the generated *client secret* and paste it into the `docker-compose.yml` file.

After you have finished the installation, go back to the terminal and bring down the running containers.

## 2. Run docker-compose.yml
Next, run the following command to start all 3 containers (IdentityServer, PaymentServer and Dashboard):

~~~
docker-compose up
~~~

The following endpoints should be available:

**Dashboard**
~~~
http://localhost:28889
~~~

**PaymentServer**
The Swagger endpoint should be available:
~~~
http://localhost:28888/swagger
~~~

**IdentityServer**
The discovery endpoint should be available:
~~~
http://localhost:28890/.well-known/openid-configuration
~~~