## Description
Script that simplifies the process of identifying and tracking Git repositories on your local machine. This tool helps you stay organized by providing a clear overview of the status and details of each repository.

## Features
- Locate and identify all Git repositories within a specified directory.
- Display detailed information for each repository:
  - Repository name
  - Path
  - Status of files (e.g., untracked or modified files)
  - Current branch
  - Latest commit (hash and message)
  - Local branches
  - Local stashes
- Error handling for repositories without commits.

## How to Use
1. Open PowerShell.
2. Navigate to the directory containing the Git Tracker script.
3. Run the script with the desired path parameter.

## Parameters
- **Path**: Specifies the directory to scan for Git repositories. The default is the root of the system directory.

## Example
`Get-GitRepoInfo -Path "C:\Path\To\Project"`
This command retrieves detailed information for a **specific Git repository** 
located at the given path (`C:\Path\To\Project`).

`Get-GitRepos -Path "C:\Path\To\Projects"`
This command scans the specified directory (`C:\Path\To\Projects`) and its subdirectories for all Git repositories.

## Features to Implement
- Provide summary statistics for all repositories, such as the number of branches or total stashes.