# GPL license.
# Edited from project Denoland install script (https://github.com/denoland/deno_install)
param (
  [string] $version
)

$PSMinVersion = 3

if ($v) {
  $version = $v
}

# Helper functions for pretty terminal output.
function Write-Part ([string] $Text) {
  Write-Host $Text -NoNewline
}

function Write-Emphasized ([string] $Text) {
  Write-Host $Text -NoNewLine -ForegroundColor "Cyan"
}

function Write-Done {
  Write-Host " > " -NoNewline
  Write-Host "OK" -ForegroundColor "Green"
}

if ($PSVersionTable.PSVersion.Major -gt $PSMinVersion) {
  $ErrorActionPreference = "Stop"

  # Enable TLS 1.2 since it is required for connections to GitHub.
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

  $checkSpice = Get-Command spicetify -ErrorAction Silent
  if ($null -eq $checkSpice) {
    Write-Host -ForegroundColor Red "Spicetify not found"
    Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression
  }

  # Check ~\.spicetify\Themes directory already exists
  $spicePath = spicetify -c | Split-Path
  $sp_dot_dir = "$spicePath\Themes"
  Write-Part "MAKING FOLDER  "; Write-Emphasized "$sp_dot_dir\DIADZ"
  Remove-Item -Recurse -Force "$sp_dot_dir\DIADZ" -ErrorAction Ignore
  New-Item -Path "$sp_dot_dir\DIADZ" -ItemType Directory | Out-Null
  Write-Done

  # Clone to .spicetify.
  Write-Part "DOWNLOADING    "; Write-Emphasized $sp_dot_dir
  Invoke-WebRequest -Uri "https://codeberg.org/DIADZ/DIADZ-Themes/raw/branch/main/themes/spicetify/DIADZ/color.ini" -UseBasicParsing -OutFile "$sp_dot_dir\DIADZ\color.ini"
  Invoke-WebRequest -Uri "https://codeberg.org/DIADZ/DIADZ-Themes/raw/branch/main/themes/spicetify/DIADZ/user.css" -UseBasicParsing -OutFile "$sp_dot_dir\DIADZ\user.css"
  Write-Done

  # Installing.
  Write-Part "INSTALLING `r`n"
  spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
  spicetify config current_theme DIADZ
  Write-Done	
  
  # applying.
  Write-Part "APPLYING";
  spicetify backup
  spicetify apply
  Write-Done
}
else {
  Write-Part "`nYour Powershell version is less than "; Write-Emphasized "$PSMinVersion";
  Write-Part "`nPlease, update your Powershell downloading the "; Write-Emphasized "'Windows Management Framework'"; Write-Part " greater than "; Write-Emphasized "$PSMinVersion"
}