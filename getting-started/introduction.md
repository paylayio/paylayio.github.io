# Introduction
PAYLAY is a complete Payments Framework solution for easily developing and integrating payment processes into your organisation's platform:
- connect to Leading Payment Service Providers
- connect to Messaging Systems
- supports Leading Database Providers

## Abstract payment layer
PAYLAY exposes a REST API and acts as an abstract payment layer to which your application communicates with, instead of directly connecting to payment providers.

**In developer lingo:** the concept is similar to the programming concepts of _interface_ and _classes_: PAYLAY is the Interface, whereas each Payment Provider is a concrete Implementation.