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
    $value = "[req]
default_bits = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
prompt = no

[req_distinguished_name]
organizationName = PAYLAY Self-Signed Development Certificate
organizationalUnitName = Self-Signed Dev Cert
commonName = PAYLAY Local Self-Signed Developer Certificate

[ usr_cert ]
basicConstraints = CA:FALSE

[req_ext]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = host.docker.internal
DNS.2 = localhost"

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
    Invoke-Expression "openssl req -new -extensions req_ext -config ""${OutputDir}$customOpenSslConfigFile"" -x509 -sha256 -days 365 -nodes -keyout ${OutputDir}$FileName.key -out ${OutputDir}$FileName.crt"
    Invoke-Expression "openssl pkcs12 -inkey ${OutputDir}$FileName.key -in ${OutputDir}$FileName.crt -export -out ${OutputDir}$FileName.p12 -name ""PAYLAY Self Signed Development Certificate: $FileName"" -password pass:$password"

    # Extract fingerprint
    $output = Invoke-Expression "openssl x509 -noout -fingerprint -sha1 -inform pem -in ${OutputDir}$FileName.crt"
    $fingerprint = $output -split "="
    return $fingerprint[1] -replace ":", "";
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

    $environmentVariables = "-e PayLay:IdentityServer:Rdbms=Sqlite -e PayLay:IdentityServer:ConnectionString=""Data Source=/paylay/identityserver.sqlite"""

    Invoke-Expression "docker run --rm ${environmentVariables} -v ${OutputDir}:/paylay paylay/identityserver:latest install --accept-eula"
    Invoke-Expression "docker run --rm -it ${environmentVariables} -v ${OutputDir}:/paylay paylay/identityserver:latest add-user ironman"
    Invoke-Expression "docker run --rm ${environmentVariables} -v ${OutputDir}:/paylay paylay/identityserver:latest seed $ClientId $ClientSecret http://localhost:28889"
}

function Install-PaymentServer {
    Invoke-Expression "docker run --rm -e PayLay:PaymentServer:Rdbms=Sqlite -e PayLay:PaymentServer:ConnectionString=""Data Source=/var/tmp/"" -v ${OutputDir}:/paylay paylay/paymentserver:latest install"
}

# main #

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

$clientId = "dashboard"
$clientSecret = [guid]::NewGuid()

Get-Docker-Images-From-Registry

Remove-Old-File -FileName $customOpenSslConfigFile
New-OpenSSL-Config -FileName $customOpenSslConfigFile

New-Pkcs -FileName "identityserver-signing"

Install-IdentityServer -ClientId $clientId -ClientSecret $clientSecret



#$devThumbprint = New-Pkcs -FileName "dev"

#$signingIdentityServerThumbprint = New-Pkcs -FileName "identityserver-signing"

#New-IdentityServer-EnvironmentVariableFile -CertificateFile "dev.p12" -CertificateThumbprint $devThumbprint -SigningCertificateFile "identityserver-signing.p12" -SigningCertificateThumbprint $signingIdentityServerThumbprint

#New-PaymentServer-EnvironmentVariableFile -CertificateFile "dev.p12" -DevThumbprint $devThumbprint
Install-PaymentServer

#New-Dashboard-EnvironmentVariableFile -DashboardCertificateFile "dev.p12" -DevThumbprint $devThumbprint -ClientId $clientId -ClientSecret $clientSecret

# Cleanup
Remove-Old-File -FileName $customOpenSslConfigFile

Write-Host ""
Write-Host ""
Write-Host "Woohoo, everything should be ready now!" -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "You can start PAYLAY with the docker-compose command:"
Write-Host ""
Write-Host "    docker-compose up" -ForegroundColor Cyan
Write-Host ""