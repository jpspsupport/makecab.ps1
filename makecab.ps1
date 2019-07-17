param(
 [Parameter(Mandatory=$true)]
 [string] $folder,   #input folder name

 [Parameter(Mandatory=$false)]
 [string] $outFile #output file name
)

if ($folder.EndsWith("\") -eq $false){
   $folder += "\"
}
".Set MaxDiskSize=0" | Out-File .\temp.ddf  -Encoding ASCII
$files = get-childitem $folder -Recurse | where { $_.Attributes -ne "Directory"}
foreach ($file in $files)
{
  $destPath = $file.FullName.Replace($folder, "")
  '"' + $file.FullName + '" "' + $destPath + '"' | Out-File -Append .\temp.ddf  -Encoding ASCII
}

makecab /f .\temp.ddf
if ([system.string]::IsNullOrEmpty($outFile))
{
  $outFile = ($folder.TrimEnd("\") + ".cab")
}

""
("Output file : " + $outFile)
""

Move-Item .\disk1\1.cab $outFile -Force
Remove-Item .\disk1
Remove-Item .\setup.inf
Remove-Item .\setup.rpt
Remove-Item .\temp.ddf
