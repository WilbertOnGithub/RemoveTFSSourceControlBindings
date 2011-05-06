# Convert *.sln files
foreach ($solution in gci -include *.sln -recurse)
{
	$file = [System.IO.File]::OpenText($Solution)
	$newSolutionFile = @()

	while (!$file.EndOfStream)
	{
		$line =$file.ReadLine()
		if ($line -match '^\s+GlobalSection\(TeamFoundationVersionControl\)')
		{
			Write-Host "Found a solution with TFS bindings in" $Solution.FullName
			Write-Host "Converting..."

			while ($line -notmatch '^\s+EndGlobalSection')
			{
				$line = $file.ReadLine()
			}

			$line = $file.ReadLine()
		}
							
		$newSolutionFile = $newSolutionFile + $line
	}
	$file.Close()

	$newSolutionFile | out-file -force -encoding ASCII ($solution.FullName)
}

# Convert *.csproj files
foreach ($project in gci -include *.csproj -recurse)
{
	Write-Host "Found a C# project file with TFS bindings in" $project.FullName
	Write-Host "Converting..."	

	Set-ItemProperty $project -name IsReadOnly -Value $false

	$xml = [xml] (Get-Content $project)

	$xml | Select-Xml -Xpath "//*[local-name() = 'SccProjectName']" | foreach {$_.Node.ParentNode.RemoveChild($_.Node)} | Out-null
	$xml | Select-Xml -Xpath "//*[local-name() = 'SccLocalPath']" | foreach {$_.Node.ParentNode.RemoveChild($_.Node)} | Out-Null
	$xml | Select-Xml -Xpath "//*[local-name() = 'SccAuxPath']" | foreach {$_.Node.ParentNode.RemoveChild($_.Node)} | Out-Null
	$xml | Select-Xml -Xpath "//*[local-name() = 'SccProvider']" | foreach {$_.Node.ParentNode.RemoveChild($_.Node)} | Out-Null

	$xml.Save($project)
}

# Remove all extra binding files
gci -include *.vs?scc -recurse | Remove-Item -force

