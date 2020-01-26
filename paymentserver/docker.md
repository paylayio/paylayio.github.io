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
### Environment variable file
Create a file called `paymentserver_env` using the content below and save the file to your PAYLAY working directory:
~~~ ini
PayLay:PaymentServer:Rdbms=Sqlite
PayLay:PaymentServer:ConnectionString=Data Source=/paylay/paymentserver.sqlite
Kestrel:Certificates:Default:Path=/paylay/{ your certificate filename } # replace
Kestrel:Certificates:Default:Password={ your password } # replace
~~~
The value of the setting `PayLay:PaymentServer:Rdbms` specifies the database provider. Here, we specify `Sqlite`. See [Supported Database Providers](/paymentserver/supported-database-providers) for all possible values.

The value `{ your certificate filename }` needs to be replaced with the filename of your PKCS#12 certificate file.

The value `{ your password }` needs to be replaced with the password of your PKCS#12 certificate file.

{{some_other_file.txt}}

### Start installation process

macOS
~~~ bash
docker run --env-file=paymentserver_env -v $PAYLAYDIR:"/paylay/" paylay/paymentserver:latest \
install
~~~

Windows
~~~ shell
docker run --env-file=paymentserver_env -v %PAYLAYDIR%:"/paylay/" paylay/paymentserver:latest ^
install
~~~

### Run application
~~~ bash
docker run --env-file=paymentserver_env -v $PAYLAYDIR:"/paylay/" -p 28888:443 paylay/paymentserver:latest \
run
~~~

After starting the PaymentServer, Swagger should be available at `https://localhost:28888/swagger`.

### Next
Now that you have the [PaymentServer](paymentserver/readme.md) up-and-running, please continue with the [Dashboard Docker Guide](dashboard/docker.md).