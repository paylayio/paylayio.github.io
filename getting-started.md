# Getting Started

## Introduction
An Environment variable file is used throughout all [Docker Guides](#Docker-Guides). It is used to store and read settings. If you require or prefer other ways of settings management, please refer to the [Docker documentation](https://docs.docker.com).

## Prerequisites
### Create a working directory
Before you continue performing steps outlined in the various Docker Guides, we ask you to create a _working directory_ on your machine where the environment variable files can be stored, and files can be persisted.

Then store the value of your working directory to the environment variable `PAYLAYDIR` so that you can simply copy-and-paste the commands in the Docker Guides.

#### macOS
~~~ bash
export PAYLAYDIR=/Users/Example/Docker
~~~

#### Linux
~~~ bash
# Example will follow soon
~~~

#### Windows
~~~ cmd
set PAYLAYDIR=C:/Users/Example/Docker
~~~

### Create self-signed certificates
SSL certificates are required for all 3 core applications.

For the convenience of local development work, we recommend that you create self-signed certificates (PKCS#12) using OpenSSL.

Instructions can be found here:
https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html

Place the certificates inside the `PAYLAYDIR` directory.

In the Docker Guide of each application, you will get specific instructions on how to reference the certificates.

## Docker Guides
When you are ready to get started with PAYLAY, we recommend you read and follow the Docker Guides in the following order:

- [IdentityServer Docker Guide](identityserver/docker.md)
- [PaymentServer Docker Guide](paymentserver/docker.md)
- [Dashboard Docker Guide](dashboard/docker.md)