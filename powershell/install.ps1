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

function New-OpenSSL-Config([string] $FileName) {
    $value = "distinguished_name = distinguished_name

[ distinguished_name ]

[ usr_cert ]
basicConstraints=CA:FALSE

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment"

    "Creating temporary OpenSSL config file $FileName at $OutputDir"
    New-Item -Path $OutputDir -Name $FileName -ItemType "file" -Value $value
}

function Remove-Old-File([string] $FileName) {
    $fullPath = "${OutputDir}${FileName}"

    "Check if file '$fullPath' exists..."

    if (Test-Path $fullPath -PathType Leaf)
    {
        "File '$fullPath' already exists: perform cleanup"
        Remove-Item -Path $fullPath
    }
}

function New-Pkcs($FileName) {
    Invoke-Expression "openssl req -config ""${OutputDir}$customOpenSslConfigFile"" -x509 -newkey rsa:4096 -sha256 -days 365 -nodes -keyout ${OutputDir}$FileName.key -out ${OutputDir}$FileName.crt -subj /CN=host.docker.internal -addext basicConstraints=critical,CA:FALSE -addext subjectAltName=DNS:localhost,DNS:host.docker.internal,IP:127.0.0.1"
    Invoke-Expression "openssl pkcs12 -inkey ${OutputDir}$FileName.key -in ${OutputDir}$FileName.crt -export -out ${OutputDir}$FileName.p12 -name ""${OutputDir}$FileName"" -password pass:$password"

    # Extract fingerprint
    $output = Invoke-Expression "openssl x509 -noout -fingerprint -sha1 -inform pem -in ${OutputDir}$FileName.crt"
    $fingerprint = $output -split "="
    return $fingerprint[1] -replace ":", "";
}

function New-IdentityServer-EnvironmentVariableFile($CertificateFile, $CertificateThumbprint, $SigningCertificateFile, $SigningCertificateThumbprint) {
    $value = "# Generated with $PSCommandPath
PayLay:IdentityServer:Rdbms=Sqlite
PayLay:IdentityServer:ConnectionString=Data Source=/paylay/identityserver.sqlite

# signing thumbprint == $SigningCertificateThumbprint
PayLay:IdentityServer:SigningCertificate:Path=/paylay/$SigningCertificateFile
PayLay:IdentityServer:SigningCertificate:Password=$password

# thumbprint == $CertificateThumbprint
Kestrel:Certificates:Default:Path=/paylay/$CertificateFile
Kestrel:Certificates:Default:Password=$password"

    Remove-Old-File -Path $OutputDir -FileName $identityServerEnvironmentFile
    New-Item -Path $OutputDir -Name $identityServerEnvironmentFile -ItemType "file" -Value $value
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

    Remove-Old-File -Path $OutputDir -FileName $paymentServerEnvironmentFile
    New-Item -Path $OutputDir -Name $paymentServerEnvironmentFile -ItemType "file" -Value $value
}

function New-Dashboard-EnvironmentVariableFile($DashboardCertificateFile, $IdentityServerThumbprint, $PaymentServerThumbprint, $ClientId, $ClientSecret) {
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
    New-Item -Path $OutputDir -Name $DashboardEnvironmentFile -ItemType "file" -Value $value
}

function Get-Docker-Images-From-Registry {
    Write-Host ""
    Write-Host "***************************************" -ForegroundColor Green
    Write-Host "*                                     *" -ForegroundColor Green
    Write-Host "* Pulling latest images from registry *" -ForegroundColor Green
    Write-Host "*                                     *" -ForegroundColor Green
    Write-Host "***************************************" -ForegroundColor Green
    Write-Host ""
    Invoke-Expression "docker pull paylay/identityserver:latest"
    ""
    Invoke-Expression "docker pull paylay/paymentserver:latest"
    ""
    Invoke-Expression "docker pull paylay/dashboard:latest"
    ""
}

function Install-IdentityServer($ClientId, $ClientSecret) {
    Write-Host ""
    Write-Host "*************************************" -ForegroundColor Green
    Write-Host "*                                   *" -ForegroundColor Green
    Write-Host "* Start IdentityServer Installation *" -ForegroundColor Green
    Write-Host "*                                   *" -ForegroundColor Green
    Write-Host "*************************************" -ForegroundColor Green
    Write-Host ""

    Invoke-Expression "docker run --rm paylay/identityserver:latest eula"
    [Console]::Out.Flush()

    $agreeWithEula = Read-Host -Prompt 'By continuing, you agree with our EULA. Continue? [Y/N]'
    if ($agreeWithEula.ToUpper() -ne "Y") {
        exit(-1)
    }

    Invoke-Expression "docker run --rm --env-file=${OutputDir}$identityServerEnvironmentFile -v ${OutputDir}:/paylay paylay/identityserver:latest install --accept-eula"
    Invoke-Expression "docker run --rm -it --env-file=${OutputDir}$identityServerEnvironmentFile -v ${OutputDir}:/paylay paylay/identityserver:latest add-user ironman"
    Invoke-Expression "docker run --rm --env-file=${OutputDir}$identityServerEnvironmentFile -v ${OutputDir}:/paylay paylay/identityserver:latest seed $ClientId $ClientSecret https://host.docker.internal:28889"
}

function Install-PaymentServer {
    Invoke-Expression "docker run --rm --env-file=${OutputDir}$paymentServerEnvironmentFile -v ${OutputDir}:/paylay paylay/paymentserver:latest install"
}

function Import-Self-Signed-Certificates {
    Write-Host ""
    Write-Host "*******************************************************" -ForegroundColor Green
    Write-Host "*                                                     *" -ForegroundColor Green
    Write-Host "* Importing certificates into local certificate store *" -ForegroundColor Green
    Write-Host "*                                                     *" -ForegroundColor Green
    Write-Host "*******************************************************" -ForegroundColor Green
    Write-Host ""
    $dashboardCert = "${OutputDir}dashboard.crt"
    $paymentServerCert = "${OutputDir}paymentserver.crt"
    $identityServerCert = "${OutputDir}identityserver.crt"

    if ($IsMacOS) {
        "Importing certificates into macOS..."
        ""
        Invoke-Expression "sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $dashboardCert"
        Invoke-Expression "sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $paymentServerCert"
        Invoke-Expression "sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $identityServerCert"
    }
    elseif ($IsLinux) {
        "Importing certificates into Linux is not yet supported..."
    }
    else {
        "Importing certificates into Windows..."
        ""
        # Invoke-Expression "certutil -enterprise -addstore Root $dashboardCert"
        # Invoke-Expression "certutil -enterprise -addstore Root $paymentServerCert"
        # Invoke-Expression "certutil -enterprise -addstore Root $identityServerCert"

        Import-Certificate -FilePath "$dashboardCert" -CertStoreLocation Cert:\LocalMachine\Root
        Import-Certificate -FilePath "$paymentServerCert" -CertStoreLocation Cert:\LocalMachine\Root
        Import-Certificate -FilePath "$identityServerCert" -CertStoreLocation Cert:\LocalMachine\Root
    }
}

# main #

Write-Host ""
Write-Host "+------------------------------------------------+" -ForegroundColor Cyan
Write-Host "|                                                |" -ForegroundColor Cyan
Write-Host "|  PAYLAY Community Edition Installation Script  |" -ForegroundColor Cyan
Write-Host "|                                                |" -ForegroundColor Cyan
Write-Host "+------------------------------------------------+" -ForegroundColor Cyan
Write-Host ""
"Hello Developer, this script will:"
""
"   1. pull the latest Docker images"
"   2. generate environment files that can be used by Docker Desktop"
"   3. generate self-signed SSL certificates for each Docker image"
"   4. install the self-signed SSL certificate into the OS certificate store"
""
Write-Host "**WARNING**: Do not use this script for production purposes!" -ForegroundColor Red
""

if ([String]::IsNullOrEmpty($OutputDir)) {
    "No output directory specified. Will use current directory"
    $OutputDir = Get-Location
}
else {
    "Output directory specified: $OutputDir"
}

$OutputDir = $OutputDir.ToString().Replace('\', '/').TrimEnd('/')
$OutputDir = "${OutputDir}/"

"All environment variable files, database files, and self-generated certificates will be saved to the following output directory: $OutputDir"
""

$customOpenSslConfigFile = "custom_openssl_config.tmp"
$identityServerEnvironmentFile = "identityserver_env"
$paymentServerEnvironmentFile = "paymentserver_env"
$dashboardEnvironmentFile = "dashboard_env"

$clientId = "dashboard"
$clientSecret = [guid]::NewGuid()

Get-Docker-Images-From-Registry

Remove-Old-File -FileName $customOpenSslConfigFile
New-OpenSSL-Config -FileName $customOpenSslConfigFile

New-Pkcs -FileName "identityserver-signing"
$identityServerThumbprint = New-Pkcs -FileName "identityserver"
$signingIdentityServerThumbprint = New-Pkcs -FileName "identityserver-signing"

New-IdentityServer-EnvironmentVariableFile -CertificateFile "identityserver.p12" -CertificateThumbprint $identityServerThumbprint -SigningCertificateFile "identityserver-signing.p12" -SigningCertificateThumbprint $signingIdentityServerThumbprint
Install-IdentityServer -ClientId $clientId -ClientSecret $clientSecret

$paymentServerThumbprint = New-Pkcs -FileName "paymentserver"
New-PaymentServer-EnvironmentVariableFile -CertificateFile "paymentserver.p12" -IdentityServerThumbprint $identityServerThumbprint
Install-PaymentServer

$_ = New-Pkcs -FileName "dashboard"
New-Dashboard-EnvironmentVariableFile -DashboardCertificateFile "dashboard.p12" -IdentityServerThumbprint $identityServerThumbprint -PaymentServerThumbprint $paymentServerThumbprint -ClientId $clientId -ClientSecret $clientSecret

Import-Self-Signed-Certificates

# Cleanup
Remove-Old-File -FileName $customOpenSslConfigFile

Write-Host ""
Write-Host ""
Write-Host "Woohoo, everything should be ready now!" -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "You can start each PAYLAY application with the following commands:"
Write-Host ""
Write-Host "   IdentityServer:"
Write-Host "       docker run --rm -it --env-file=${OutputDir}identityserver_env -v ${OutputDir}:/paylay/ -p 28890:28890 paylay/identityserver:latest run" -ForegroundColor Cyan
Write-Host ""
Write-Host "   PaymentServer:"
Write-Host "       docker run --rm -it --env-file=${OutputDir}paymentserver_env -v ${OutputDir}:/paylay/ -p 28888:28888 paylay/paymentserver:latest run" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Dashboard:"
Write-Host "       docker run --rm -it --env-file=${OutputDir}dashboard_env -p 28889:28889 -v ${OutputDir}:/paylay/ paylay/dashboard:latest run" -ForegroundColor Cyan
Write-Host ""
Write-Host ""