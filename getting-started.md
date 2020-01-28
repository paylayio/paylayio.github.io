# Getting Started

## Introduction
An Environment variable file is used throughout all [Docker Guides](#Docker-Guides). It is used to store and read settings. If you require or prefer other ways of settings management, please refer to the [Docker documentation](https://docs.docker.com).

## Prerequisites
### Create a working directory
Before you continue performing steps outlined in the various Docker Guides, we ask you to create a _working directory_ on your machine where the environment variable files can be stored, and files can be persisted.

Then store the value of your working directory to the environment variable `PAYLAYDIR` so that you can simply copy-and-paste the commands in the Docker Guides.

#### Linux
~~~ bash
# Example will follow soon
~~~

#### macOS
~~~ bash
export PAYLAYDIR=/Users/Example/Docker
~~~

#### Windows
~~~ shell
set PAYLAYDIR=C:/Users/Example/Docker
~~~

## Steps
We recommend you do things in the following order:

1. All PAYLAY core applications require an SSL certificate. For convenience and development purposes only, please read how to [Create Self-Signed Certificates](create-self-signed-certificates.md).
Then place the certificates inside the `PAYLAYDIR` directory.

Follow the instructions in the following Docker Guides:

2. [IdentityServer Docker Guide](identityserver/docker.md)
3. [PaymentServer Docker Guide](paymentserver/docker.md)
4. [Dashboard Docker Guide](dashboard/docker.md)