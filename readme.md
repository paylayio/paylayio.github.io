PAYLAY
======
PAYLAY is a Payments Framework solution for easily developing and integrating eCommerce processes into your organisation's platform.

PAYLAY is striving to be technology-agnostic so that you can continue using your favorite development tools and deploy to any environment you prefer or already have.

## Ecosystem
The PAYLAY ecosystem consists of 3 core applications.

### PaymentServer
The PAYLAY _PaymentServer_ application is a middleware for your eCommerce platform. Your eCommerce platform only needs to talk to the PaymentServer, which will then perform the heavy lifting of handling various eCommerce operations. This way, you can develop eCommerce processes before you have chosen a specific Payment Service Provider, easily switch to another Payment Service Provider without making code changes to your eCommerce platform, or support multiple Payment Service Providers.

[More about the PaymentServer](/paymentserver/readme.md)

### Dashboard
The PAYLAY _Dashboard_ is an application for managing various configurations, viewing aggregated payment statistics, and performing various eCommerce related operations.

[More about the Dashboard](Dashboard.md)

### IdentityServer
![alt text](http://wiki.openid.net/f/openid-logo-wordmark.png "OpenID Connect logo")

The PAYLAY _IdentityServer_ is responsible for OpenID Connect authentication and authorization and grants your organisation's users access to the [Dashboard](dashboard.md), as well as issuing access tokens in order for the Dashboard to access the PaymentServer.

You are encouraged to use your organisation's existing OpenID Connect provider for this purpose.
This barebones IdentityServer is currently only meant to bootstrap your development process.

[More about the IdentityServer](IdentityServer.md)

### More apps
In the future, more apps will become available in the PAYLAY ecosystem to support the following areas:
- Business Intelligence
- Subscription
- PSD2

## Docker
All applications are distributed via Docker images.