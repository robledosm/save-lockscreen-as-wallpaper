# Save lockscreen as wallpaper

Powershell script to copy the Windows 10 lockscreens to be used as wallpapers. 

The script takes the files from the assets folder ($env:USERPROFILE \AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*) and based on its dimension it copies the HD pictures to $env:USERPROFILE\Pictues\Wallpapers
