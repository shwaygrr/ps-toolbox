function Get-DirectorySize {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    $totalSizeBytes = (Get-ChildItem -Path $path -Recurse -File | Measure-Object -Property length -Sum).Sum
    $totalSizeKB = [math]::Round($totalSizeBytes / 1KB, 2) #convert to KB
    
    return $totalSizeKB
}

function Remove-NodeModules {
    [CmdletBinding()]
    param (
        [string]$Path
    )

    #get assessment decision
    $wantAssessment = Read-Host -Prompt "Would like an assessment before deletion? (Y/N) Default is No" 

    #search and delete
    Switch ($wantAssessment) {
        "Y" {
            $modulesArr = Get-ChildItem -Path $Path -Filter "node_modules" -Recurse -Directory | 
                Where-Object { $_.Parent.FullName -notmatch "\\node_modules" }

            #assessment            
            Write-Host ("There are {0} node_modules folders in the folder" -f $modulesArr.Length)
            
            $modulesArr | ForEach-Object { Write-Host $_.FullName }

            $parentSize = Get-DirectorySize -Path $Path
            If ($parentSize -ne 0) {
                $modulesSize = 0
                Foreach ($module in $modulesArr) {
                    $modulesSize += Get-DirectorySize -Path $module.FullName 
                }
                Write-Host ("Node modules folders are taking up {0}% of parent folder" -f (($modulesSize / $parentSize) * 100))
            } Else {
                Write-Host "Parent Folder is 0 KB"
            }

            $readyDelete = Read-Host -Prompt "Ready to delete?(Y/N) Default is Yes"
            
            #delete files
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
}

Remove-NodeModules -Path "C:\Users\15616\OneDrive\Documents\Fall 2023"