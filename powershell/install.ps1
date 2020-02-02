#Requires -RunAsAdministrator

param(
    [ValidateScript({
        if (-Not ($_ | Test-Path)) {
            throw "Output directory '$_' does not exist"
        }
        return $true
    })]
    [string] $OutputDir,
    [string] $Password = [guid]::NewGuid()
)

function New-OpenSSL-Config([string] $Path, [string] $FileName)
{
    $value = "distinguished_name = distinguished_name

[ distinguished_name ]

[ usr_cert ]
basicConstraints=CA:FALSE

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment"

    "Creating temporary OpenSSL config file $FileName at $Path"
    New-Item -Path $Path -Name $FileName -ItemType "file" -Value $value
}

function Remove-Old-File([string] $FileName)
{
    $fullPath = "${cwd}${FileName}"

    if (Test-Path $fullPath -PathType Leaf)
    {
        "Removing file: $fullPath"
        Remove-Item -Path $fullPath
    }
}

function New-Pkcs([string] $FileName)
{
    $FileName = $cwd + $FileName

    Invoke-Expression "openssl req -config ""$customOpenSslConfigFile"" -x509 -newkey rsa:4096 -sha256 -days 365 -nodes -keyout $FileName.key -out $FileName.crt -subj /CN=host.docker.internal -addext basicConstraints=critical,CA:FALSE -addext subjectAltName=DNS:localhost,DNS:host.docker.internal,IP:127.0.0.1"
    Invoke-Expression "openssl pkcs12 -inkey $FileName.key -in $FileName.crt -export -out $FileName.p12 -name ""$FileName"" -password pass:$password"

    # Extract fingerprint
    $output = Invoke-Expression "openssl x509 -noout -fingerprint -sha1 -inform pem -in $FileName.crt"
    $fingerprint = $output -split "="
    return $fingerprint[1] -replace ":", "";
}

function New-IdentityServer-EnvironmentVariableFile($Path, $CertificateFile, $CertificateThumbprint, $SigningCertificateFile, $SigningCertificateThumbprint)
{
    $value = "# Generated with $PSCommandPath
PayLay:IdentityServer:Rdbms=Sqlite
PayLay:IdentityServer:ConnectionString=Data Source=/paylay/identityserver.sqlite

# signing thumbprint == $SigningCertificateThumbprint
PayLay:IdentityServer:SigningCertificate:Path=/paylay/$SigningCertificateFile
PayLay:IdentityServer:SigningCertificate:Password=$password

# thumbprint == $CertificateThumbprint
Kestrel:Certificates:Default:Path=/paylay/$CertificateFile
Kestrel:Certificates:Default:Password=$password"

    Remove-Old-File -Path $Path -FileName $identityServerEnvironmentFile
    New-Item -Path $Path -Name $identityServerEnvironmentFile -ItemType "file" -Value $value
}

function New-PaymentServer-EnvironmentVariableFile($CertificateFile, $IdentityServerThumbprint) {
    $value = "# Generated by $PSCommandPath
PayLay:PaymentServer:Rdbms=Sqlite
PayLay:PaymentServer:ConnectionString=Data Source=/paylay/paymentserver.sqlite

#
PayLay:PaymentServer:Authentication:Authority=https://host.docker.internal:28890

# The following variables are only needed for self-signed certificates
PayLay:PaymentServer:Authentication:ServerCertificateCustomValidation:Enabled=true
PayLay:PaymentServer:Authentication:ServerCertificateCustomValidation:Thumbprint=$IdentityServerThumbprint

#
Kestrel:Certificates:Default:Path=/paylay/$CertificateFile
Kestrel:Certificates:Default:Password=$password"

    Remove-Old-File -FileName $paymentServerEnvironmentFile
    New-Item -Path $cwd -Name $paymentServerEnvironmentFile -ItemType "file" -Value $value
}

function New-Dashboard-EnvironmentVariableFile($DashboardCertificateFile, $IdentityServerThumbprint, $PaymentServerThumbprint, $ClientId, $ClientSecret)
{
    $value = "# Generated by $PSCommandPath
PayLay:Dashboard:IdentityServer:Authority=https://host.docker.internal:28890
PayLay:Dashboard:IdentityServer:ClientId=$ClientId
PayLay:Dashboard:IdentityServer:ClientSecret=$ClientSecret
#
PayLay:Dashboard:IdentityServer:ServerCertificateCustomValidation:Enabled=True
PayLay:Dashboard:IdentityServer:ServerCertificateCustomValidation:Thumbprint=$IdentityServerThumbprint
#
PayLay:Dashboard:PaymentServer:Uri=https://host.docker.internal:28888
PayLay:Dashboard:PaymentServer:ServerCertificateCustomValidation:Enabled=True
PayLay:Dashboard:PaymentServer:ServerCertificateCustomValidation:Thumbprint=$PaymentServerThumbprint
#
Kestrel:Certificates:Default:Path=/paylay/$DashboardCertificateFile
Kestrel:Certificates:Default:Password=$password"

    Remove-Old-File -FileName $DashboardEnvironmentFile
    New-Item -Path $cwd -Name $DashboardEnvironmentFile -ItemType "file" -Value $value
}

function Get-Docker-Images-From-Registry
{
    ""
    "***************************************"
    "*                                     *"
    "* Pulling latest images from registry *"
    "*                                     *"
    "***************************************"
    ""
    Invoke-Expression "docker pull paylay/identityserver:latest"
    ""
    Invoke-Expression "docker pull paylay/paymentserver:latest"
    ""
    Invoke-Expression "docker pull paylay/dashboard:latest"
    ""
}

function Install-IdentityServer($ClientId, $ClientSecret)
{
    ""
    "*************************************"
    "*                                   *"
    "* Start IdentityServer Installation *"
    "*                                   *"
    "*************************************"
    ""
    Invoke-Expression "docker run paylay/identityserver:latest eula"

    # $agreeWithEula = Read-Host -Prompt 'By continuing, you agree with our EULA. Continue? (Y/N)'

    # if ($agreeWithEula -ne 'Y')
    # {
    #     return;
    # }

    Invoke-Expression "docker run --rm --env-file=$identityServerEnvironmentFile -v ${cwd}:/paylay paylay/identityserver:latest install --accept-eula"
    Invoke-Expression "docker run --rm -it --env-file=$identityServerEnvironmentFile -v ${cwd}:/paylay paylay/identityserver:latest add-user ironman"
    Invoke-Expression "docker run --rm --env-file=$identityServerEnvironmentFile -v ${cwd}:/paylay paylay/identityserver:latest seed $ClientId $ClientSecret https://host.docker.internal:28889"
}

function Install-PaymentServer
{
    Invoke-Expression "docker run --rm --env-file=$paymentServerEnvironmentFile -v ${cwd}:/paylay paylay/paymentserver:latest install"
}

function Import-Self-Signed-Certificates([string] $Path) {
    ""
    "*******************************************************"
    "*                                                     *"
    "* Importing certificates into local certificate store *"
    "*                                                     *"
    "*******************************************************"
    ""
    Import-Certificate -FilePath "${Path}dashboard.crt" -CertStoreLocation Cert:\LocalMachine\Root
    Import-Certificate -FilePath "${Path}paymentserver.crt" -CertStoreLocation Cert:\LocalMachine\Root
    Import-Certificate -FilePath "${Path}identityserver.crt" -CertStoreLocation Cert:\LocalMachine\Root
}

# main #

""
"+------------------------------------------------+"
"|                                                |"
"|  PAYLAY Community Edition Installation Script  |"
"|                                                |"
"+------------------------------------------------+"
""
"Hello Developer, this script will:"
""
"   1. pull the latest Docker images"
"   2. generate environment files that can be used by Docker Desktop"
"   3. generate self-signed SSL certificates for each Docker image"
"   4. install the self-signed SSL certificate into the OS certificate store"
""
"**WARNING**: Do not use this script for production purposes!"
""

if ($null -eq $OutputDir)
{
    $cwd = Get-Location
}
else
{
    $cwd = $OutputDir
}

$cwd = $cwd.Replace('\', '/').TrimEnd('/')
$cwd = "${cwd}/"

"All environment variable files, database files, and self-generated certificates will be saved to the following output directory: $cwd"
""

$customOpenSslConfigFile = "custom_openssl_config.tmp"
$identityServerEnvironmentFile = "identityserver_env"
$paymentServerEnvironmentFile = "paymentserver_env"
$dashboardEnvironmentFile = "dashboard_env"

$clientId = "dashboard"
$clientSecret = [guid]::NewGuid()

Get-Docker-Images-From-Registry

Remove-Old-File -Path $cwd -FileName $customOpenSslConfigFile
New-OpenSSL-Config -Path $cwd -FileName $customOpenSslConfigFile

New-Pkcs "identityserver-signing"
$identityServerThumbprint = New-Pkcs -FileName "identityserver"
$signingIdentityServerThumbprint = New-Pkcs "identityserver-signing"
New-IdentityServer-EnvironmentVariableFile -Path $cwd -CertificateFile "identityserver.p12" -CertificateThumbprint $identityServerThumbprint -SigningCertificateFile "identityserver-signing.p12" -SigningCertificateThumbprint $signingIdentityServerThumbprint
Install-IdentityServer -ClientId $clientId -ClientSecret $clientSecret

$paymentServerThumbprint = New-Pkcs -FileName "paymentserver"
New-PaymentServer-EnvironmentVariableFile -CertificateFile "paymentserver.p12" -IdentityServerThumbprint $identityServerThumbprint
Install-PaymentServer

$_ = New-Pkcs -FileName "dashboard"
New-Dashboard-EnvironmentVariableFile -DashboardCertificateFile "dashboard.p12" -IdentityServerThumbprint $identityServerThumbprint -PaymentServerThumbprint $paymentServerThumbprint -ClientId $clientId -ClientSecret $clientSecret

Import-Self-Signed-Certificates -Path $cwd

# Cleanup
Remove-Old-File -Path $cwd -FileName $customOpenSslConfigFile

""
""
"Woohoo, everything should be ready now!"
""
""
"You can start each PAYLAY application with the following commands:"
""
"   IdentityServer:"
"       docker run --rm -it --env-file=identityserver_env -v ${cwd}:/paylay/ -p 28890:28890 paylay/identityserver:latest run"
""
"   PaymentServer:"
"       docker run --rm -it --env-file=paymentserver_env -v ${cwd}:/paylay/ -p 28888:28888 paylay/paymentserver:latest run"
""
"   Dashboard:"
"       docker run --rm -it --env-file=dashboard_env -p 28889:28889 -v ${cwd}:/paylay/ paylay/dashboard:latest run"
""