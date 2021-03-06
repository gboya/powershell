#powershell profile of bpatr
$backupDrive = "Z:/"
$repo = "C:/gitDev4.1"

#Subsample of the powershell community extensions
function Invoke-BatchFile
{
    param([string]$Path, [string]$Parameters)  

    $tempFile = [IO.Path]::GetTempFileName()  

    ## Store the output of cmd.exe.  We also ask cmd.exe to output   
    ## the environment table after the batch file completes  
    cmd.exe /c " `"$Path`" $Parameters && set > `"$tempFile`" " 

    ## Go through the environment variables in the temp file.  
    ## For each of them, set the variable in our local environment.  
    Get-Content $tempFile | Foreach-Object {   
        if ($_ -match "^(.*?)=(.*)$")  
        { 
            Set-Content "env:\$($matches[1])" $matches[2]  
        } 
    }  

    Remove-Item $tempFile
}

function Import-VS2008Vars
{
    Invoke-BatchFile "${env:VS90COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
}

function Import-VS2010Vars
{
    Invoke-BatchFile "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
}

function Import-VS2012Vars
{
    Invoke-BatchFile "${env:VS110COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
	#VCVARS invoke in VS2012 are silent...
    Write-Host "VS2012 vcvars loaded..."
}

function Kill-Vs 
{
	Get-Process | Where-Object {$_.ProcessName -eq "devenv"} | ForEach-Object {kill $_.Id}
}

function Kill-Exlorer 
{
	Get-Process | Where-Object {$_.ProcessName -eq "explorer"} | ForEach-Object {kill $_.Id}
}

function Kill-Cassini 
{
	Get-Process | Where-Object {$_.ProcessName -eq "WebDev.WebServer"} | ForEach-Object {kill $_.Id}
}


function Backup-Git
{
		
	$backupGit = (Join-Path -path $backupDrive -childpath .git)
	$repoGit = (Join-Path -path $repo -childpath .git)
	
	if(Test-Path $backupGit){
		Write-Host "Start removing previous .git repo in:" $backupGit
		Remove-Item -Recurse -Force $backupGit
		Write-Host "Removing .git repo finished!"
	}
	
	Write-Host "Start copying .git repo from:" $repoGit "in:" $backupGit
	Copy-Item $repoGit $backupGit -recurse -Force
	Write-Host "Copying .git finished."
	Write-Host "Copying .gitignore"
	Copy-Item (Join-Path -path $repo -childpath .gitignore) (Join-Path -path $backupDrive -childpath .gitignore)
	Write-Host "Backup completed"
}
