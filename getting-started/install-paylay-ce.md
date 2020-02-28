---
layout: default
title: Install PAYLAY CE
parent: Getting Started
nav_order: 2
---

# Install PAYLAY CE
The easiest way to install PAYLAY CE is to download the following Docker Compose files:

- [installation.yml](/docker/installation.yml)
- [docker-compose.yml](/docker/docker-compose.yml)

Fire up a terminal or commandline to get started.

## 1. Run installation.yml
~~~
docker-compose -f installation.yml up
~~~

This instruction will create and start 2 containers: the IdentityServer and PaymentServer.

### Database installation
Navigate to the IdentityServer endpoint
~~~
http://localhost:28890/installation
~~~

Follow the instructions to install the database, and add an **initial user** and **client**.

On the final screen, a generated **client secret** will be shown. Copy it.

Now, open the file `docker-compose.yml`, find the key `paylay:dashboard:authentication:clientsecret:` and paste the **client secret** next to it.

Example:
~~~
paylay:dashboard:authentication:clientsecret: YOUR_CLIENT_SECRET
~~~

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

## Next up
Congratulations, you have just installed PAYLAY CE on your local development machine.

Proceed with the [tutorial](tutorial.md) on how to create your first payment.