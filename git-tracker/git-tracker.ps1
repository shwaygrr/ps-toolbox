function Get-GitRepoInfo {
  param (
    [string]$Path
  )

  if (!(Test-Path -Path "$Path/.git")) {
    Write-Error -Message "Directory is not a git repository"
    return
  }
  
  Set-Location $Path

  try {
    $repoName = Split-Path -Leaf $Path

    $status = (git status --short) -join "; "
        
    $hasCommits = git rev-parse --verify HEAD 2>$null
    $currentBranch = "main (inferred)"
    $latestCommit = "No commits"
    
    if ($hasCommits) {
      $currentBranch = git rev-parse --abbrev-ref HEAD  
      $latestCommit = (git show -s --format=%h:%B HEAD) -join " "
    }
    
    $branches = (git branch --format="%(refname:short)") -join ", "
    if (-not $branches) {
      $branches = "main (inferred)"
    }

    $stashes = (git stash list) -join "; "
    if (-not $stashes) {
        $stashes = "No stashes"
    }

    [PSCustomObject]@{
      RepositoryName = $repoName
      Path           = $Path
      Status         = $status
      CurrentBranch  = $currentBranch
      LatestCommit   = $latestCommit
      Branches       = $branches
      Stashes        = $stashes
    }
  } catch {
    Write-Error "Error with repository: $_"
  }  
  finally {
    Pop-Location
  }
}

function Get-GitRepos {
  param (
    # optional parameter with default value as the system root directory
    [string]$Path = [System.IO.Path]::GetPathRoot([System.Environment]::SystemDirectory)
  )

  $gitRepos = Get-ChildItem -Path $Path -Force -Directory -Recurse -Filter ".git"
  $gitRepos | ForEach-Object {
    Get-GitRepoInfo -Path $_.Parent.FullName
  }
}