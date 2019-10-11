PaymentServer
=============

## How it works
The PaymentServer exposes a REST API. This is the single API interface to which your eCommerce platform(s) will talk to.

A swagger endpoint is available and accessable from `localhost`.

## Features

### Checkout
Your application sends a checkout request to the PaymentServer, which will then translate the request into one that can be understood by the Payment Service Provider.

### Webhook handling
The PaymentServer will handle incoming webhooks sent by various Payment Service Provider(s).

### Payment Status
Whenever the PaymentServer receives a payment status update, it will publish this information in JSON format to your eCommerce platform(s)/system(s). You can configure your preferred way of communication:

- Webhooks

In the near future, we will add support for:
- Amazon SQS
- Apache Kafka
- Azure Servicebus
- Google Cloud Pub/Sub
- RabbitMQ

### Payment Routing
You can define payment routes for the following purposes:
- A/B Testing
- Criteria-based Payment traffic distribution over 2+ Payment Service Providers
- Payment Service Provider Fallback

## Prerequisites

### Database Server
The PaymentServer requires a database server to create a database in order to persist configuration and operational data.

Each new version of the PaymentServer may come with small changes in the database scheme. These changes are applied automatically when you run the PaymentServer update.

[Supported Databases](#Supported-Databases)

### Reverse Proxy
The PaymentServer is meant to run in your internal network and should **only** have the `Webhook` endpoint exposed to the Internet in order to reduce the attack surface. Therefore, it needs to be placed behind a Reverse Proxy web server.

#### Apache
~~~
Instructions will follow
~~~

#### IIS
~~~
Instructions will follow
~~~

#### Nginx
~~~
Instructions will follow
~~~

### OpenID Connect Provider
The PaymentServer requires an OpenID Connect Provider for authentication and token issuance. PayLay offers a barebones IdentityServer that can easily be deployed in your Development environment. We recommend that you use your existing OpenID Connect provider and authorization server instead.

### Management Studio
PayLay comes with a Management Studio application that allows you to configure Payment Service Provider connectors, payment routing, etc. as well as viewing aggregated statistics, performing refunds, etc.

## Community vs Enterprise
The Community and Enterprise Edition of the PaymentServer are identical. The only difference is in the support of various database providers.

### Supported Databases

| Feature           | Community | Enterprise     |
|-------------------|-----------|----------------|
| In-Memory         | ✔️️        | ️-              |
| Sqlite            | ✔️️️️️        | -              |
| MySql             | -         | ✔️️             |
| Sql Server        | -         | ✔️️             |
| Azure Cosmos      | -         | Future release |
| PostgreSQL        | -         | Future release |
| Firebird          | -         | Future release |
| Oracle DB 11.2+   | -         | Future release |
| Db2               | -         | Future release |