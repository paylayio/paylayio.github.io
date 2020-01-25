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
For this guide, we use an Environment variable file to store and read settings. If you require or prefer other ways of settings management, please refer to the [Docker documentation](https://docs.docker.com).

### Environment variable file

Create a file called `env_dashboard` containing the following contents:
~~~ ini
PayLay:Dashboard:IdentityServerUri=https://localhost:28890
PayLay:Dashboard:PaymentServerUri=https://localhost:28888
PayLay:Dashboard:ClientId=dashboard
PayLay:Dashboard:ClientSecret=# your secret #
~~~

You need to set the `PayLay:Dashboard:ClientSecret` variable with the **client secret** value that was generated in the last step of the [IdentityServer Docker Guide](/identityserver/docker.md).

### Run
~~~ bash
docker run --env-file=env_dashboard -p 28889:80 paylay/dashboard:latest run
~~~

After running this command, navigate to `http://localhost:28889`.

### Next
You have now set up all 3 docker images. Go and follow the [Getting Started Guide](getting-started-guide.md) on how to start integrating.