---
layout: default
title: Tutorial
parent: Getting Started
nav_order: 3
---
# Tutorial
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

Yay, you have just installed PAYLAY CE using the [Docker Compose guide](/getting-started/docker).

In this tutorial, we will show you the exact steps that you need to take in order to get started.

## 1. Log into the Dashboard
Navigate to the dashboard endpoint and log in:

~~~
http://localhost:28889
~~~

### 1.1. Add and Configure an Integration
Every application that you integrate with the PaymentServer is called an **Integration**.

Navigate to the Integrations page, and add a new Integration. An API Key will be generated for every Integration that you add. The API Key is needed for every API request to the PaymentServer.

![screenshot](/images/screenshots/add-integration.png)

### 1.2. Add a Payment Provider to your Integration

Before you are able to add a Payment Provider to your Integration, you should have (created) a [Payment Provider](/paymentserver/supported-payment-providers.md) account and obtained some test/production authentication credentials (API key, secret, or equivalent).

Once you have that, add the Payment Provider in the Dashboard, and enter the authentication credential of the Payment Provider.

### 1.3. Configure a Notification Provider

Your application should act on every [Payment Status Change](/paymentserver/paymentstatus), e.g. topping up credits, proceeding with the fulfilment process. In order to get these notifications, you should add a Notification Provider.

You are not obliged to configure this step, though.

### 1.4. Configure a Payment Routing Rule

You must configure a Payment Routing Rule. This is how the PaymentServer decides which Payment Provider will handle a [Payment Request](/paymentserver/payment-request).

Leave all conditions blank to make a Payment Provider the preferred supplier.

## 2. Create our first payment

Now that we have configured 1 Payment Provider, we can start our first payment.

Navigate to the Swagger endpoint to play with the API:
~~~
http://localhost:28888/swagger
~~~

### 2.1. Set API Key

![screenshot](/images/screenshots/swagger-top.png)

Click on the **Authorize** button with lock icon and enter the API Key of the Integration that you just created.

### 2.2. Call PaymentRequest

![screenshot](/images/screenshots/swagger-post-api-payment.png)

Find the `POST /api/Payment` endpoint to create a new payment.

The `PaymentRequest` and `PaymentRequestResponse` schemas ares well-documented in the Swagger tool, so please use the Swagger tool as your main source of documentation.