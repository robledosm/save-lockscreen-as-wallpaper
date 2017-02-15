param (
    [string] 
    $savePath = "$($env:USERPROFILE)\Pictures\Wallpapers"
)

if (-not (Test-Path("$savePath"))) { New-Item $savePath -ItemType Directory -Force | Out-Null }

$assetsPath = "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager*\LocalState\Assets"
$guid = [System.Guid]::NewGuid().guid
$tempPath = "$savePath\$guid"
New-Item $tempPath -ItemType Directory -Force | Out-Null

$assets = Get-ChildItem -Path "$assetsPath\*" | Where-Object { $_.Length -gt 200kb }

$count = 0
foreach($asset in $assets)
{
    $saveImagePath = "$savePath\$($asset.Name).png"
    if (-not (Test-Path($saveImagePath))) {
        $tempImagePath = "$tempPath\$($asset.Name).png"
        Copy-Item $asset.FullName $tempImagePath
        $image = New-Object -comObject WIA.ImageFile
        $image.LoadFile($tempImagePath)
        if($image.Width.ToString() -eq "1920") {
            Move-Item $tempImagePath $saveImagePath -Force 
            $count++
        }
    }
}
Remove-Item $tempPath -Recurse
Write-Host "$count new pictures found"
