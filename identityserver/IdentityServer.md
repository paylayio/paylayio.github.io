---
layout: default
title: IdentityServer
nav_order: 5
has_children: true
permalink: identityserver
---
# IdentityServer

An OpenID Connect provider plays a **central part** in the PAYLAY ecosystem. All PAYLAY apps require this for authentication and authorization.

![alt text](http://wiki.openid.net/f/openid-logo-wordmark.png "OpenID Connect logo")

PAYLAY provides a simple OpenID Connect provider called *IdentityServer* to bootstrap the development process on your local developer machine.

For production purposes, we recommend you using your existing OpenID Connect provider solution.

## Prerequisites
The IdentityServer requires a database for persisting data. The supported databases are:

- Sqlite

## Community vs Enterprise
At the moment, PAYLAY only offers a Community Edition of the IdentityServer.

### Supported Databases

| Feature           | Community |
|-------------------|-----------|
| Sqlite            | ✔️️️️️        |
