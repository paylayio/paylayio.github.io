---
layout: default
title: AppSettings
parent: Getting Started
nav_order: 4
---
# AppSettings
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Configuration sources
Each PAYLAY microservice is configurable. Configuration is based on key-value pairs. We refer to application configuration as **AppSettings**.

Key-value pairs are loaded from a variety of sources, in the following order:

**1. appsettings.json**

Each microservice contains its own `appsettings.json` file with default settings.

⚠️ You should **never** mount a file to the Docker container to overwrite the content of this file.

**2. appsettings.custom.json**

To deviate from some values in the default `appsettings.json`, mount a `appsettings.custom.json` file from outside the Docker container to `/app/appsettings.custom.json` inside the container.

Only include deviating sections inside the `appsettings.custom.json` file.

**3. environment variables**

Pass environment variables to the PAYLAY microservice using Docker's environment variable mechanisms.

💡It is important to know that source 3 overwrites appsettings from source 2, and so on.

## .NET Core AppSettings
PAYLAY microservices are built on top of .NET Core. Therefore, you can also configure the internal components of the microservices.

### Kestrel
All microservices internally use the [Kestrel webserver](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-3.1). If needed, you can customize Kestrel's behavior.

For example, if you wish to configure SSL certificates, you just need to have the following section in your `appsettings.custom.json` file:

~~~ json
"Kestrel": {
    "Certificates": {
        "Default": {
            "Path": "cert.p12",
            "Password": "secret"
        }
    }
}
~~~

or if you wish to use environment variables:
~~~
kestrel:certificates:default:path=cert.p12
kestrel:certificates:default:password=secret
~~~

### Logging
https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-3.1