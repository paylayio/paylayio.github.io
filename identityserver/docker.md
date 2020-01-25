# IdentityServer Docker Guide
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
This instruction guide tells you how to install the PAYLAY [IdentityServer](IdentityServer/readme.md) Community Edition for **local development purposes**.

## Pull the image
~~~ bash
docker pull paylay/identityserver:latest
~~~

## View EULA
We kindly ask you to read the EULA first:
~~~ bash
docker run paylay/identityserver:latest eula
~~~

By performing the installation in the next step, you are accepting our EULA.

## Installation
For this guide, we use an Environment variable file to store and read settings. If you require or prefer other ways of settings management, please refer to the [Docker documentation](https://docs.docker.com).

### Environment variable file

Create a file called `env_file` containing the following contents, and save it to a location on your machine. We refer to this location as `/users/example/docker` for the remainder of this guide.
~~~ ini
PayLay:IdentityServer:Rdbms=Sqlite
PayLay:IdentityServer:ConnectionString=Data Source=/paylay/identityserver.sqlite
~~~
The value of the setting `PayLay:IdentityServer:Rdbms` specifies the database provider. Here, we specify `Sqlite`. See [Supported Database Providers](/identityserver/supported-database-providers) for all possible values.

The value of the setting `PayLay:IdentityServer:ConnectionString` specifies the connection string of the database provider. Here, we specify that the database schema and data needs to be persisted to a file called `/paylay/identityserver.sqlite`.

### Start the installation process
~~~ bash
docker run \
--env-file=env_file
-v "/users/example/docker":"/paylay/" \
paylay/identityserver:latest \
install --accept-eula
~~~

In the above step, we use Docker Environment variables to set settings required by IdentityServer.

In this case, we persist the database to a file, and because of that, we need to mount a directory of the host machine to the Docker container. In this case we mount the host machine directory `/users/example/docker` to `/paylay/`. Of course, your directory will be different than what is described in this guide.

### Add initial user
~~~ bash
docker run \
--env-file=env_file
-v "/users/example/docker":"/paylay/" \
-it \
paylay/identityserver:latest \
add-user ironman
~~~
Here, we create a user called `ironman`.

You will be prompted to enter the password for your initial user. Don't forget it. There is no password retrieval functionality in the current Community Edition.

### Add client
Next, we need to add a client called `dashboard`, which later we will use as `client_id` for our [Dashboard](dashboard/readme.md) application.

~~~ bash
docker run \
--env-file=env_file
-v "/users/example/docker":"/paylay/" \
paylay/identityserver:latest \
seed dashboard https://localhost:28889
~~~

A **client secret** will be generated for the client and shown to you. You will need to use it later in the [Dashboard Docker Guide](dashboard/docker.md).
The client secret is only shown once and cannot be retrieved later on. Please keep a copy of the secret for now.

### Run
Now you are ready to run the IdentityServer.

~~~ bash
docker run \
--env-file=env_file
-v "/users/example/docker":"/paylay/" \
-p 28890:80 \
paylay/identityserver:latest \
run
~~~

The IdentityServer is available at `http://localhost:28890`

## SSL
We will soon add instructions for setting up SSL with IdentityServer.

## Next up...
Now that you have finished setting up the IdentityServer, please proceed with the [PaymentServer Docker Guide](/PaymentServer/docker.md).