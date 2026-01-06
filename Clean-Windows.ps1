#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Simple Windows 10 Bloatware Removal Script
.DESCRIPTION
    Removes built-in apps (bloatware) and unnecessary optional features from Windows 10.
    Must be run as Administrator.
.VERSION
    1.0
#>

Write-Host "Starting Windows 10 Bloatware Removal..." -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Yellow

#region Remove Built-in Apps (Bloatware)
Write-Host "Removing Built-in Apps..." -ForegroundColor Cyan

$AppsToRemove = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingFinance",
    "Microsoft.BingFoodAndDrink",
    "Microsoft.BingHealthAndFitness",
    "Microsoft.BingMaps",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingTranslator",
    "Microsoft.BingTravel",
    "Microsoft.BingWeather",
    "Microsoft.FreshPaint",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.HelpAndTips",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.MinecraftUWP",
    "Microsoft.MixedReality.Portal",
    "Microsoft.MSPaint",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.News",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Sway",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.Reader",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.Wallet",
    "Microsoft.Whiteboard",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "microsoft.windowscommunicationsapps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsPhone",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "EclipseManager",
    "ActiproSoftwareLLC",
    "Adobe.FlashPlayerforWindows10",
    "Facebook.Facebook",
    "Flipboard.Flipboard",
    "ShazamEntertainmentLtd.Shazam",
    "SpotifyAB.SpotifyMusic",
    "Twitter.Twitter",
    "TuneIn.TuneInRadio",
    "Microsoft.Advertising.Xaml"
)

foreach ($App in $AppsToRemove) {
    try {
        Write-Host "Removing: $App" -ForegroundColor Yellow
        Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $App | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Host "✓ Removed: $App" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed to remove $App" -ForegroundColor Red
    }
}

#endregion

#region Remove Optional Windows Features
Write-Host "Removing Optional Windows Features..." -ForegroundColor Cyan

$FeaturesToRemove = @(
    "Internet-Explorer-Optional-amd64",
    "WindowsMediaPlayer",
    "MediaPlayback",
    "WorkFolders-Client",
    "Printing-XPSServices-Features",
    "SMB1Protocol"
)

foreach ($Feature in $FeaturesToRemove) {
    try {
        Write-Host "Removing feature: $Feature" -ForegroundColor Yellow
        $result = Disable-WindowsOptionalFeature -Online -FeatureName $Feature -NoRestart -ErrorAction SilentlyContinue
        if ($result.RestartNeeded -eq $true) {
            Write-Host "✓ Removed: $Feature (restart required)" -ForegroundColor Green
        } else {
            Write-Host "✓ Removed: $Feature" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Failed to remove $Feature" -ForegroundColor Red
    }
}

#endregion

Write-Host "=====================================" -ForegroundColor Yellow
Write-Host "Bloatware removal completed!" -ForegroundColor Green
Write-Host "You may need to restart your computer for all changes to take effect." -ForegroundColor Yellow

# Prompt for restart
$restart = Read-Host "Would you like to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 5 seconds..." -ForegroundColor Red
    Start-Sleep -Seconds 5
    Restart-Computer -Force
}
