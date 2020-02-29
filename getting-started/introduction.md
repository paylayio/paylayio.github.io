---
layout: default
title: Introduction
parent: Getting Started
nav_order: 1
---
# Introduction
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

PAYLAY is a complete Payments Framework solution for easily developing and integrating payment processes into your organisation's platform:
- connect to Leading Payment Service Providers
- connect to Messaging Systems
- supports Leading Database Providers

## Audience
This guide was written for developers and people in technical roles. 

## Why PAYLAY?
The PAYLAY ecosystem acts as an *abstract payment layer* to which your application communicates with, instead of directly connecting to payment providers.

PAYLAY already did the heavy lifting for you: we have implemented a set of Payment Providers.

So once you have implemented PAYLAY, you can simply pick a Payment Provider and start processing payments.

This means that when you need a new Payment Provider there is no need to read through lengthy documentation (again) 👍 Not only will it save you time, you now have more time for coding ❤️

You can compare this to the programming concept of _interface_ and _classes_. PAYLAY acts as the interface, whereas each Payment Provider is a concrete implementation.

## Microservices Architecture
The PAYLAY ecosystem was designed and built according to a microservices architecture.

It consists of a collection of independently deployable services, with each service serving a specific function.

We have the following microservices:

### [PaymentServer](/paymentserver)
Headless microservice that exposes a [REST API](/paymentserver/rest-api) that allows your application to perform payment requests without having to know the specific implementation details of the payment provider.

### [Dashboard](/dashboard)
This microservice depends on the PaymentServer and acts as the presentation layer of the PaymentServer. It allows the user to configure API keys, view real-time payment information, perform refunds, etc.

### [IdentityServer](/identityserver)
This microservice acts as the authentication provider that allows users to _Single Sign On_ into the PAYLAY ecosystem.

_We will insert some nice architecture image here_ (soon hopefully 😅)

We expect to have more microservices in the future that will extend the possibility of PAYLAY.

If you wish to develop microservices for the PAYLAY ecosystem, please contact us at info[at]paylay.io

## Docker
All microservices are available via Docker images. They can be deployed to any environment that supports containerization: on-premise or in the cloud.

## Database
PAYLAY microservices that require a database could support a set of Database Providers such as MySql and SqlServer.

## AppSettings
Each microservice can be configured for your specific use case using environment variables, or JSON configuration files.

## Community vs Enterprise
PAYLAY is available as a Community Edition (CE) and an Enterprise Edition (EE).

The CE comes with a smaller set of supported Payment Providers and Database Providers.

## Try out PAYLAY yourself
We believe that the best way to understand PAYLAY is to simply try it out.

We have written a [concise installation guide](/getting-started/install-paylay-ce) where you can install all PAYLAY microservices on your **local dev machine** in matter of minutes.