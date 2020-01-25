# IdentityServer Docker Guide
This instruction guide tells you how to install the PAYLAY IdentityServer Community Edition for local development purposes.

## Pull the image
~~~
docker pull paylay/identityserver:latest
~~~

## How to use this image

### View EULA
We kindly ask you to read the EULA first:
~~~
$ docker run paylay/identityserver:latest eula
~~~

By performing the installation in the next step, you are accepting our EULA.

### Installation

~~~ bash
docker run \
-e PayLay:IdentityServer:Rdbms="Sqlite" \
-e PayLay:IdentityServer:ConnectionString="Data Source=/paylay/identityserver.sqlite" \
-v "/Users/huyhoang/Docker":"/paylay/" \
paylay/identityserver:latest \
install --accept-eula
~~~

In the above step, we use Docker Environment variables to set settings required by IdentityServer.

The value of the setting `PayLay:IdentityServer:Rdbms` specifies the Database provider. Here, we specify `Sqlite`.

The value of the setting `PayLay:IdentityServer:ConnectionString` specifies the connection string. Here, we specify that the database schema and data needs to be persisted to a file called `/paylay/identityserver.sqlite`.

In this case, we persist the database to a file, and because of that, we need to mount a directory of the host machine to the Docker container. In this case we mount the host machine directory `/Users/PayLay/Docker` to `/paylay/`. Depending on your OS and/or username, your directory will be different.

### Add initial user
~~~ bash
docker run \
-e PayLay:IdentityServer:Rdbms="Sqlite" \
-e PayLay:IdentityServer:ConnectionString="Data Source=/paylay/identityserver.sqlite" \
-v "/Users/huyhoang/Docker":"/paylay/" \
-it \
paylay/identityserver:latest \
add-user ironman
~~~

You will be prompted to enter the password for your initial user. Don't forget it. There is no password retrieval functionality in the current Community Edition.

### Seed client
You need to seed data for your first client: the Dashboard application.

~~~ bash
docker run \
-e PayLay:IdentityServer:Rdbms="Sqlite" \
-e PayLay:IdentityServer:ConnectionString="Data Source=/paylay/identityserver.sqlite" \
-v "/Users/huyhoang/Docker":"/paylay/" \
paylay/identityserver:latest \
seed dashboard https://localhost:28889
~~~

A secret will be generated for the client and shown to you. The secret is only shown once and cannot be retrieved later on. Please keep a copy of the secret for now.

### Run
Now you are ready to run the IdentityServer.

~~~ bash
docker run \
-e PayLay:IdentityServer:Rdbms="Sqlite" \
-e PayLay:IdentityServer:ConnectionString="Data Source=/paylay/identityserver.sqlite" \
-v "/Users/huyhoang/Docker":"/paylay/" \
-p 28890:80 \
-e Logging:LogLevel:System="Debug" \
-e Logging:LogLevel:Default="Debug" \
-e Logging:LogLevel:Microsoft="Debug" \
paylay/identityserver:latest \
run
~~~

The IdentityServer is available at `http://localhost:28890`

### SSL
We will soon add instructions for setting up SSL with IdentityServer.

### Next up...
Now that you have finished setting up the IdentityServer, please proceed with the [PaymentServer Docker Guide](/PaymentServer/docker.md).