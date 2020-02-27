---
layout: default
title: Dashboard
nav_order: 4
has_children: true
permalink: dashboard
---

# Dashboard

The Dashboard is a front-end application that allows you to interact with the [PaymentServer](PaymentServer.md) in order to query payment information &amp; statistics, and configure the PaymentServer.

## Main Features

### Configure Payment Providers

### Configure Notification Providers

### Configure Payment Routing

## Prerequisites
- The [PaymentServer](/paymentserver/readme.md) exposes private endpoints that allows the Dashboard to create, read, update, and delete data.
- The [IdentityServer](/identityserver/readme.md) application is required for authentication, as well as issuing tokens for accessing the aforementioned private endpoints. You are free to substitute [IdentityServer](/identityserver/readme.md) with any OpenID Connect and OAuth2.0 Provider.

## Community vs Enterprise
More information will follow
