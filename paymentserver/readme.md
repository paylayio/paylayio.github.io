---
layout: default
title: PaymentServer
nav_order: 3
has_children: true
permalink: paymentserver
---

PaymentServer
=============
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## What is it?
The PAYLAY PaymentServer application is a middleware for your eCommerce platform. Your eCommerce platform only needs to talk to the PaymentServer, which will then perform the heavy lifting of handling various eCommerce operations. This way, you can develop eCommerce processes before you have chosen a specific Payment Service Provider, easily switch to another Payment Service Provider without making code changes to your eCommerce platform, or support multiple Payment Service Providers.

## Installation

### Prerequisites

#### Database Server
The PaymentServer requires a database server to create a database in order to persist configuration and operational data.

Each new version of the PaymentServer may come with small changes in the database scheme. These changes are applied automatically when you run the PaymentServer migration.

[Supported Databases](#supported-databases)

## How it works
The PaymentServer exposes a [REST API](rest-api.md). This is the single API interface to which your eCommerce platform(s) will talk to.

A swagger endpoint is available when you are running the PaymentServer on your `localhost` development machine.

## Features

### Middleware
Your application sends an API request to the PaymentServer, which will then translate the request into one that can be understood by the Payment Service Provider.

See a list of [Supported Payment Providers](supported-payment-providers.md).

### Webhook handling
The PaymentServer will handle incoming webhooks sent by various Payment Service Provider(s).

### Payment Status
Whenever the PaymentServer receives a payment status update, it will publish this information in JSON format to your eCommerce platform(s)/system(s). You can configure your preferred way of communication:

- Webhooks
- RabbitMQ

In the near future, we will add support for:
- Amazon SQS
- Apache Kafka
- Azure Servicebus
- Google Cloud Pub/Sub

### Payment Routing
You can define payment routes for the following purposes:
- A/B Testing
- Criteria-based Payment traffic distribution over 2+ Payment Service Providers
- Payment Service Provider Fallback

## Prerequisites

### Reverse Proxy
The PaymentServer is meant to run in your internal network and should **only** have the `Webhook` endpoint exposed to the Internet in order to receive payment webhooks from Payment Service Providers, and to reduce the attack surface. Therefore, it needs to be placed behind a Reverse Proxy web server.

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
The PaymentServer requires an OpenID Connect Provider for authentication and token issuance. PAYLAY offers a barebones IdentityServer that can easily be deployed in your Development environment. We recommend that you use your existing OpenID Connect provider and authorization server instead.

### Dashboard
PAYLAY comes with a [Dashboard](/dashboard/readme.md) application that allows you to configure Payment Service Provider connectors, payment routing, etc. as well as viewing aggregated statistics, performing refunds, etc.

## Community vs Enterprise
The Community and Enterprise Edition of the PaymentServer are identical. The only difference is in the support of various database providers.

### Supported Databases

| Feature           | Community | Enterprise     |
|-------------------|-----------|----------------|
| In-Memory         | ✔️️        | -              |
| Sqlite            | ✔️️️️️        | -              |
| MySql             | -         | ✔️️             |
| Sql Server        | -         | ✔️️             |
| Azure Cosmos      | -         | Future release |
| PostgreSQL        | -         | Future release |
| Firebird          | -         | Future release |
| Oracle DB 11.2+   | -         | Future release |
| Db2               | -         | Future release |

## More resources
