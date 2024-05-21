function Get-DirectorySize {
    param(
        [String]$Path
    )
    $totalSizeBytes = (Get-ChildItem -Path $path -Recurse -File | Measure-Object -Property length -Sum).Sum
    $totalSizeKB = [math]::Round($totalSizeBytes / 1KB, 2) #convert to KB
    
    return $totalSizeKB
}

#path of folder to search for node modules
$path = "C:\Users\15616\OneDrive\Documents\Fall 2023\Prin. of SWE\hw3"

#get assessment decision
$wantAssessment = Read-Host -Prompt "Would like an assessment before deletion? (Y/N) Default is No" 

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

        $readyDelete = Read-Host -Prompt "Ready to delete?(Y/N) Default is Yes"
        
        If ($readyDelete -ne "N") {
            $modulesArr | ForEach-Object { Remove-Item -Path $_.FullName -Force -Recurse }
            Write-Host "Deletions complete"
        }

        break
    }

    default {
        Get-ChildItem -Path $path -Filter "node_modules" -Recurse -Directory | 
            Where-Object { $_.Parent.FullName -notmatch "\\node_modules" } |
            Foreach-Object { Remove-Item -Path $_.FullName -Force -Recurse }
        
        Write-Host "Deletions complete"
        break
    }
}