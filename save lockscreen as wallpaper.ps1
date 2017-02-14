param (
    [string]
    $savePath = "$($env:USERPROFILE)\Pictures\Wallpapers3"
)

$assetsPath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager*\LocalState\Assets"
$guid = [System.Guid]::NewGuid().guid
$tempPath = "$savePath\$guid"
New-Item $tempPath -Type Directory -Force | Out-Null
$count = 0
Get-ChildItem "$assetsPath\*" | % {
    if (((Get-Item $_).Length -gt 200kb) -and (-not (Test-Path("$savePath\$($_.Name).png")))) {
        Copy-Item $_.FullName "$tempPath\$($_.Name).png"
        $image = New-Object -comObject WIA.ImageFile
        $image.LoadFile("$tempPath\$($_.Name).png")
        if($image.Width.ToString() -eq "1920") {
            Move-Item "$tempPath\$($_.Name).png" $savePath -Force 
            $count++
        }
    }
}
Write-Host "$count new pictures found"