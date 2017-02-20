param (
    [string] 
    $savePath = "$($env:USERPROFILE)\Pictures\Wallpapers"
)

if (-not (Test-Path("$savePath"))) { New-Item $savePath -ItemType Directory -Force | Out-Null } #Create the destination folder if it does not exists

$guid = [System.Guid]::NewGuid().guid
$tempPath = "$savePath\$guid"
New-Item $tempPath -ItemType Directory -Force | Out-Null #Create temp folder

$assetsPath = "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager*\LocalState\Assets"
$assets = Get-ChildItem -Path "$assetsPath\*" | Where-Object { $_.Length -gt 200kb } #Get assets with more than 200kb

[string[]]$skip =  '8b74981a36852521d967ca3f56fea420788993d927db53b5f7cb57f6cf217e99' 

$count = 0
foreach($asset in $assets)
{
    $finalImagePath = "$savePath\$($asset.Name).png"
    if (($skip -notcontains $asset.Name) -and (-not (Test-Path($finalImagePath)))) { #If the file does not exist in the skip array and does not already exists in its final destination
        $tempImagePath = "$tempPath\$($asset.Name).png"
        Copy-Item $asset.FullName $tempImagePath #Copy the file to the temp folder adding .png as extension
        $image = New-Object -comObject WIA.ImageFile
        $image.LoadFile($tempImagePath)
        if($image.Width.ToString() -eq "1920") { #If the image is 1920 pixels width...
            Move-Item $tempImagePath $finalImagePath -Force #Move it to its final destination
            $count++
        }
    }
}

Remove-Item $tempPath -Recurse
Write-Host "$count new pictures found"
