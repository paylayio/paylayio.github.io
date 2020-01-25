# PaymentServer Docker Guide
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
This guide can help you easily install the PAYLAY PaymentServer Community Edition for local development purposes.

## Pull the image
~~~
docker pull paylay/paymentserver:latest
~~~

## Installation
For this guide, we use an Environment variable file to store and read settings. If you require or prefer other ways of settings management, please refer to the [Docker documentation](https://docs.docker.com).

### Environment variable file

Create a file called `paymentserver_env` containing the following contents:
~~~ ini
PayLay:PaymentServer:Rdbms=Sqlite
PayLay:PaymentServer:ConnectionString=Data Source=/paylay/paymentserver.sqlite
~~~
The value of the setting `PayLay:PaymentServer:Rdbms` specifies the database provider. Here, we specify `Sqlite`. See [Supported Database Providers](/paymentserver/supported-database-providers) for all possible values.

Save the file to a location on your machine. We refer to this location as `/users/example/docker` for the remainder of this guide.
**Warning:** you should change this value to whatever you want.

### Start installation process
~~~ bash
docker run \
--env-file=paymentserver_env \
-v "/users/example/docker":"/paylay/" \
paylay/paymentserver:latest \
install
~~~

### Run application
~~~ bash
docker run \
--env-file=paymentserver_env \
-v "/users/example/docker":"/paylay/" \
-p 28888:80 \
paylay/paymentserver:latest \
run
~~~

After starting the PaymentServer, Swagger should be available at `http://localhost:28888/swagger`.

### Next
Now that you have the [PaymentServer](paymentserver/readme.md) up-and-running, please continue with the [Dashboard Docker Guide](dashboard/docker.md).