---
layout: default
title: AppSettings
parent: PaymentServer
nav_order: 10
---

# AppSettings

The PaymentServer can be configured using [AppSettings](/getting-started/appsettings) to tailor to your specific needs.

## Keys

The following keys can be set via environment variables, or the AppSettings JSON file:

~~~ ini
paylay:paymentserver:rdbms
# Indicates the database provider to use.
# Supported values: `sqlite` (CE/EE), `mysql` (EE), `sqlserver` (EE)

paylay:paymentserver:connectionstring
# The connection string needed to connect to the database provider,
# e.g. "DataSource=/tmp/db.sqlite"

paylay:paymentserver:publicwebhookhost
# Set the public facing host of the PaymentServer.
# This value is *important* because it is needed in order to receive webhooks from Payment Providers.

paylay:paymentserver:testing:enabled
# A boolean value indicating that the PAYLAY Test Provider is enabled.
# This should be **disabled** on Production.

paylay:paymentserver:authentication:authority
# The IdentityServer host

paylay:paymentserver:connectors:notificationproviders:rabbitmq:enabled
# A boolean value indicating if the RabbitMq background service should run.

paylay:paymentserver:connectors:notificationproviders:rabbitmq:hostname
# The hostname of the RabbitMQ server.

paylay:paymentserver:connectors:notificationproviders:rabbitmq:username
# The username to use for login.

paylay:paymentserver:connectors:notificationproviders:rabbitmq:password
# The password to use for login.

paylay:paymentserver:swagger:enabled
# A boolean value indicating if the Swagger endpoint should be available.
~~~













