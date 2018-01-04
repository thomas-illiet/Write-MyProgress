<#PSScriptInfo
	.VERSION 1.0.0
	.GUID caf7fc16-8f02-4247-a4b4-d026b98d6c16
	.AUTHOR thomas.illiet
	.COMPANYNAME netboot.fr
	.COPYRIGHT (c) 2017 Netboot. All rights reserved.
	.TAGS Tools
	.LICENSEURI https://raw.githubusercontent.com/Netboot-France/Write-MyProgress/master/LICENSE
	.PROJECTURI https://github.com/Netboot-France/Write-MyProgress
#> 

<#  
      .SYNOPSIS  
      Displays a progress bar within a Windows PowerShell command window.

      .DESCRIPTION
      The Write-Progress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.
      
      .NOTES  
            File Name  : Write-MyProgress.ps1
            Author     : Thomas ILLIET, contact@thomas-illiet.fr
            Date       : 2017-05-10
            Last Update: 2017-07-26
            Version    : 1.0.0
            
      .PARAMETER id
            Specifies an ID that distinguishes each progress bar from the others.
      
      .PARAMETER ParentId
      Specifies the parent activity of the current activity.
      
      .PARAMETER StartTime
      StartTime of the foreach processing
      
      .PARAMETER Object
      Object use in your foreach processing
      
      .PARAMETER Count
      Foreach Count status

      .EXAMPLE  
            $GetProcess = Get-Process

      $Count = 0
      $StartTime = Get-Date
      foreach($Process in $GetProcess)
      {
            $Count++
            Write-MyProgress -StartTime $StartTime -Object $GetProcess -Count $Count

            write-host "-> $($Process.ProcessName)"
            Start-Sleep -Seconds 1
      }
#>
Param(
      [parameter(Mandatory=$true)]
      [Array]$Object,
      [parameter(Mandatory=$true)]
      [DateTime]$StartTime,
      [parameter(Mandatory=$true)]
      [Int]$Count,
      [parameter(Mandatory=$false)]
      [Int]$Id=1,
      [parameter(Mandatory=$false)]
      [Int]$ParentId=-1
)

$SecondsElapsed = ((Get-Date) - $StartTime).TotalSeconds
$SecondsRemaining = ($SecondsElapsed / ($Count / $Object.Count)) - $SecondsElapsed

$Argument = @{
      Activity = "Processing Record $Count of $($Object.Count)"
      PercentComplete = (($Count/$($Object.Count)) * 100)
      CurrentOperation = "$("{0:N2}" -f ((($Count/$($Object.Count)) * 100),2))% Complete"
      SecondsRemaining = $SecondsRemaining
}

if($Id -ne $null) { $Argument += @{ Id = $Id } }
if($ParentId -ne $null) { $Argument += @{ ParentId = $ParentId } }

Write-Progress @Argument