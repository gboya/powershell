function Save-Jpeg (
    [string]$imagePath, 
    [string]$imageOutPut,
    $quality = $(if ($quality -lt 0 -or  $quality -gt 100){throw( "quality must be between 0 and 100.")})
    ){ 
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $bmp = New-Object System.Drawing.Bitmap $imagePath
    
    #Encoder parameter for image quality 
    $myEncoder = [System.Drawing.Imaging.Encoder]::Quality
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1) 
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder, $quality)
    
    # get codec
    $myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|where {$_.MimeType -eq 'image/jpeg'}
    
    #save to file
    $bmp.Save($imageOutPut,$myImageCodecInfo, $($encoderParams))
} 

$allChild = Get-ChildItem $folderPath -R | Where-Object {($_.Extension -eq ".JPG") -or ($_.Extension -eq ".jpg")}
$totalCount = $allChild.Count
Write-Host $totalCount "jpeg files found..."
$count = 0
foreach($file in $allChild)
{
    $count = $count+1
    Write-Host $count "file processed on" $totalCount
}

$path = Join-Path -path $pwd -ChildPath "IMGP0138.JPG"
$outpath = Join-Path -path $pwd -ChildPath "IMGP0138Copy.JPG"

#Save-Jpeg $path.toString() $outpath.toString() 75