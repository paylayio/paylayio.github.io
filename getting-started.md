# Getting Started

## Introduction
We have prepared a [PowerShell Core installation script](./powershell/install.ps1) that helps you set up the PAYLAY Community Edition ecosystem in minutes.

What will the script do in general?
- it will pull the latest Docker images of our 3 core applications
- install the applications (a Sqlite database is generated wherever this is needed)
- generate self-signed certificates
- install the self-signed certificates to your local certificate store

### Prerequisites for macOS
In order to run the installation script, you need to have PowerShell Core installed on your Mac.

You can install PowerShell Core using Homebrew.

If the `brew` command is not found, then please [install Homebrew first](https://brew.sh).

~~~ bash
brew cask install powershell
~~~

After that, fire up PowerShell Core:
~~~
./pwsh
~~~

### Installation instructions
Fire up PowerShell, navigate to the directory where the installation script is located, and type in:
~~~
./install.ps1
~~~

That's it!

Follow the instructions during the installation and happy coding!