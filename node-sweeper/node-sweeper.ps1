function Get-DirectorySize {
    param(
        [String]$Path
    )
    $totalSizeBytes = (Get-ChildItem -Path $path -Recurse -File | Measure-Object -Property length -Sum).Sum
    $totalSizeKB = [math]::Round($totalSizeBytes / 1KB, 2) #convert to KB
    
    return $totalSizeKB
}

#path of folder to search for node modules
$path = "C:\Users\15616\OneDrive\Desktop\Practice"

#get assessment decision
$wantAssessment = "N"
do {
    $wantAssessment = Read-Host -Prompt "Would like an assessment before deletion? (Y/N)" 
} while ($wantAssessment -ne "N" -and $wantAssessment -ne "Y")

#search and delete
Switch ($wantAssessment) {
    "Y" {
        $modulesArr = Get-ChildItem -Path $path -Filter "node_modules" -Recurse -Directory | 
            Where-Object { $_.Parent.FullName -notmatch "\\node_modules" }

        #assessment
        $parentSize = Get-DirectorySize -Path $path
        $modulesSize = 0

        Foreach ($module in $modulesArr) {
            $modulesSize += Get-DirectorySize -Path $module.FullName 
        }

        Write-Host ("There are {0} node_modules folders in the {1} folder" -f $modulesArr.Length, $path)
        Write-Host ("node_module folders are taking up {0}% of {1} folder space" -f ($modulesSize / $parentSize * 100), $path)

        $readyDelete = 'N'
        
        do {
            $readyDelete = Read-Host -Prompt "Ready to delete?(Y/N)" 
        } while ($readyDelete -ne 'N' -and $readyDelete -ne "Y")
        
        If ($readyDelete -eq "Y") {
            $modulesArr | ForEach-Object { Remove-Item -Path $_.FullName -Force }
            Write-Host "Deletions complete"
        }
        break
    }

    "N" {
        Get-ChildItem -Path $path -Filter "node_modules" -Recurse -Directory | 
            Where-Object { $_.Parent.FullName -notmatch "\\node_modules" } |
            Foreach-Object { Remove-Item -Path $_.FullName -Force }
        
        Write-Host "Deletions complete"
        break
    }
}