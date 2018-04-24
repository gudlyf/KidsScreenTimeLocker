# Helper functions for building the class
$script:nativeMethods = @();
function Register-NativeMethod([string]$dll, [string]$methodSignature)
{
$script:nativeMethods += [PSCustomObject]@{ Dll = $dll; Signature = $methodSignature; }
}
function Add-NativeMethods()
{
$nativeMethodsCode = $script:nativeMethods | % { "
[DllImport(`"$($_.Dll)`")]
public static extern $($_.Signature);
" }

Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class NativeMethods {
$nativeMethodsCode
}
"@
} 

Register-NativeMethod "user32.dll" "bool LockWorkStation()"
Add-NativeMethods

# Prompt for time

# Dialog prompt
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$intReturn = $timertimemins = [Microsoft.VisualBasic.Interaction]::InputBox("Enter time in minutes", "Timer Time", 60)

if ($intReturn -eq 0 -or $intReturn -eq "") { exit }

$timertime = ([int]$timertimemins * 60)

# Timer Popup
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$Form = New-Object System.Windows.Forms.Form
$Font = New-Object System.Drawing.Font("Impact",18,[System.Drawing.FontStyle]::Regular)
$Form.Font = $Font
$Form.Width = 350
$Form.Height = 80
$Form.AutoSize = $True
$Form.AutoSizeMode = "GrowAndShrink"
$script:Label = New-Object System.Windows.Forms.Label
$script:Label.AutoSize = $true
$script:Form.Controls.Add($Label)
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 1000
$script:CountDown = $timertime
$Timer.add_Tick(
    {
        $CountDownMins = [math]::Round($CountDown / 60)
        If($CountDown -lt 120) {
           $script:Label.Text = "Your system will lock in $CountDown seconds"
        }
        Else {
          $script:Label.Text = "Your system will lock in $CountDownMins minutes"
        }
        $script:CountDown--
        If($CountDown -lt 300) {
          $Form.BackColor = "Red"
        }
        If($CountDown -lt 0) {
          $script:Timer.Stop()
          $script:Form.Close()
        }
    }
)
$script:Timer.Start()
$script:Form.ShowDialog()
[NativeMethods]::LockWorkStation()
