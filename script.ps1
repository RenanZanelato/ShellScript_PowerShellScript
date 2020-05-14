#Requires -RunAsAdministrator

$FolderToCheck=$args[0];
$TypeDll=$args[1];

$ActualFolder=(Get-Location).Path;
$MESFolder="$ActualFolder/Mes";
$ABIFolder="$MESFolder/ABI.Global";
$ArrLocalToSave=@("$ABIFolder/TrakSYS","C:\Program Files (x86)\Parsec\TrakSYS","C:\Program Files (x86)\Parsec\TrakSYS\ts\bin");
$ArrDllToCheck=@("Core","Modules");
$FILE_EXIST=1;
$FILE_DOEST_EXIST=2;
$TYPE_DLL_DEBUG="Debug";
$TYPE_DLL_RELEASE="Release";

function CopyFilesToFolder {
 param( [string]$LocalFile, [string]$LocalToSave )
 cp $LocalFile $LocalToSave;
 Write-Host "$LocalFile save to $LocalToSave \n";
}

function CheckFileExist
{
	param([string]$LocalFile)
	return Test-Path $LocalFile -PathType leaf;
}
function CheckFolderExist
{
	param([string]$LocalFile)
	return Test-Path $LocalFile;
}

if ([string]::IsNullOrEmpty($FolderToCheck))
{
    Write-Host "You need to informate the local name";
    exit;
}

if ( $TypeDll -ne $TYPE_DLL_RELEASE)
{
    $TypeDll=$TYPE_DLL_DEBUG;
}

$FolderDll="$ABIFolder/ABI.Global.$FolderToCheck/bin/$TypeDll"

if(CheckFolderExist $FolderDll -eq )
{
	Write-Host "We will get the DLL IN $FolderDll ";
	
	if((get-process 'ModuleManagerService' -ea SilentlyContinue) -eq $Null) {
    		Write-Host "TrakSYS Data Management Service not running"
	} else {
		Stop-Process -Name 'ModuleManagerService' -PassThru -Force
    		Write-Host "TrakSYS Data Management Service stopped"
	}
	foreach($Dll in $ArrDllToCheck)
	{
		Write-Host "********** Starting $Dll OPERATION ******************** ";
		$File="$FolderDll/ABI.Global.$DLL.dll";
		Write-Host "-- First Local to get $File --";
		if(CheckFileExist $File -eq){
			foreach($LocalToSave in $ArrLocalToSave)
			{
				if(CheckFolderExist $LocalToSave -eq){
					CopyFilesToFolder $File $LocalToSave;
				}
			}
		} else {
			Write-Host "-- OH SHIT, $File Doesn't Exist :( --";
		}
		Write-Host "********** Ending $Dll OPERATION ******************** ";
	}
	Write-Host "START DMS ";
	Get-Service -name 'TrakSYSDataManagementService*' | Start-Service
	exit;
}
Write-Host "$FolderDll DOES NOT EXIST ";
