param (
    [string] 
    $savePath = "$($env:USERPROFILE)\Pictures\Wallpapers"
)

if (-not (Test-Path("$savePath"))) { New-Item $savePath -ItemType Directory -Force | Out-Null } #Create the destination folder if it does not exists

$guid = [System.Guid]::NewGuid().guid
$tempPath = "$savePath\$guid"
New-Item $tempPath -ItemType Directory -Force | Out-Null #Create temp folder

[string[]]$skip =  '8b74981a36852521d967ca3f56fea420788993d927db53b5f7cb57f6cf217e99', '390b0ea66bb431a9cfdb4ad8957e91368cee38f4de703bfd69c353f664dc9e7f'  #List of images to skip
$assetsPath = "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager*\LocalState\Assets"

$assets = Get-ChildItem -Path "$assetsPath\*" | Where-Object { ($_.Length -gt 200kb) -and ($skip -notcontains $_.Name) } #Get assets with more than 200kb and not in the skip list

$count = 0
foreach($asset in $assets)
{
    $finalImagePath = "$savePath\$($asset.Name).png"
    if (-not (Test-Path($finalImagePath))) { #If the file does not exists in its final destination
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

Remove-Item $tempPath -Recurse #remove temp folder and files
Write-Host "$count new pictures found"
