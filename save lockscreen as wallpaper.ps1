
function Get-FileDimensionAndPath
{ 
Param([string]$folder) 
    $shell = New-Object -ComObject Shell.Application 
    $shellFolder = $shell.namespace($folder) 

    foreach ($file in $shellFolder.items()) 
    {   
        $hash =@{
            Dimensions = $shellFolder.getDetailsOf($file, 31)
            Path = $shellFolder.getDetailsOf($file, 187)
        }
        $fileMetaData = New-Object PSObject -Property $hash
        $fileMetaData 
    } 
} 

$assetsPath =  $env:USERPROFILE + "\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*"
$destinationPath = $env:USERPROFILE + "\Pictures\Wallpapers"
$tempPath = $destinationPath + "\" + [System.Guid]::NewGuid().guid
New-Item $tempPath -type directory -Force | Out-Null
Write-Host "Creating temp directory $tempPath"
Copy-Item $assetsPath $tempPath
Write-Host "Getting files from assets foler" 
Get-ChildItem $tempPath | Rename-Item -NewName { $_.Name + ".png" }
Write-Host "Copying HD pictures to its final destination $destinationPath"
$count = 0
Get-FileDimensionAndPath -folder $tempPath | % { 
    if ($_.Dimensions -eq "1920 x 1080") { 
        Copy-Item $_.Path $destinationPath
        $count ++
    }
}
Write-Host "$count HD pictures copied"
Write-Host "Removing temp directory $tempPath" 
Remove-Item $tempPath -Force -Recurse
Write-Host "Done! =)"