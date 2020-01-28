# Dashboard Docker Guide
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
This guide can help you easily install the PAYLAY Dashboard Community Edition for local development purposes.

## Pull the image
~~~ bash
docker pull paylay/dashboard:latest
~~~

## Installation
### Environment variable file
Create a file called `dashboard_env` using the content below and save the file to your PAYLAY working directory:
~~~ ini
PayLay:Dashboard:IdentityServerUri=https://localhost:28890
PayLay:Dashboard:PaymentServerUri=https://localhost:28888
PayLay:Dashboard:ClientId=dashboard
PayLay:Dashboard:ClientSecret={ your client secret } # replace
Kestrel:Certificates:Default:Path=/paylay/{ your certificate filename } # replace
Kestrel:Certificates:Default:Password={ your password } # replace
~~~
You need to replace `{ your client secret }` with the **client secret** value that was generated in the last step of the [IdentityServer Docker Guide](/identityserver/docker.md).

The value `{ your certificate filename }` needs to be replaced with the filename of your PKCS#12 certificate file.

The value `{ your password }` needs to be replaced with the password of your PKCS#12 certificate file.

### Run

#### macOS
{: .no_toc }
~~~ bash
docker run --env-file=dashboard_env -p 28889:80 -v $PAYLAYDIR:/paylay/ paylay/dashboard:latest run
~~~

#### Windows
~~~ bash
docker run --env-file=dashboard_env -p 28889:80 -v %PAYLAYDIR%:/paylay/ paylay/dashboard:latest run
~~~

After running this command, navigate to `http://localhost:28889`.

### Next
You have now set up all 3 docker images. Go and follow the [Getting Started Guide](getting-started-guide.md) on how to start integrating.