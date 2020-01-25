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

Create a file called `env_dashboard` containing the following contents:
~~~ ini
PayLay:Dashboard:IdentityServerUri=https://localhost:28890
PayLay:Dashboard:PaymentServerUri=https://localhost:28888
PayLay:Dashboard:ClientId=dashboard
PayLay:Dashboard:ClientSecret={ your client secret } # replace with your client secret #
Kestrel:Certificates:Default:Path=/paylay/{ your certificate filename } # replace with your certificate name
Kestrel:Certificates:Default:Password={ your password } # replace with your certificate password
~~~
You need to set the `PayLay:Dashboard:ClientSecret` variable with the **client secret** value that was generated in the last step of the [IdentityServer Docker Guide](/identityserver/docker.md).

### Run
~~~ bash
docker run --env-file=env_dashboard -p 28889:80 paylay/dashboard:latest run
~~~

After running this command, navigate to `http://localhost:28889`.

### Next
You have now set up all 3 docker images. Go and follow the [Getting Started Guide](getting-started-guide.md) on how to start integrating.