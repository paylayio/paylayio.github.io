# Run PAYLAY using Docker Compose
The easiest way to run PAYLAY is to download the following Docker Compose files:

[installation.yml](installation.yml)
[docker-compose.yml](docker-compose.yml)

Fire up a terminal or commandline and get started.

## 1. Set environment variable
First, set an environment variable called `PAYLAY_DIR`.

#### Windows
~~~
$env:PAYLAY_DIR="c:/temp"
~~~

#### macOS
~~~
export PAYLAY_DIR=/tmp
~~~

## 2. Run installation.yml
~~~
docker-compose -f installation.yml up
~~~

This instruction will create and start 2 containers: the IdentityServer and PaymentServer.

The PaymentServer installation will happen on the background: a Sqlite database file will be created and written to the specified `PAYLAY_DIR`.

### 2.1 Install IdentityServer
The IdentityServer endpoint `http://localhost:28890` should be available.

Navigate to `http://localhost:28890/installation` and follow the instructions.
One of the final instructions is to copy the *client secret* and paste it into the `docker-compose.yml` file.

After you have finished the instructions, go back to the terminal and stop the 2 running containers by simply pressing `CTRL+C`.

## 3. Run docker-compose.yml
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