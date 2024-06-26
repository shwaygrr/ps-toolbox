## Description
Script designed to simplify the cleanup of unnecessary node_modules directories in your projects. If you're a web developer like me, you know how quickly these folders can accumulate and eat up disk space.

This script automates the process of finding and removing node_modules directories, saving you time and effort. It's a handy tool for keeping your development environment clean and organized, especially if you have multiple projects with nested node_modules folders.

## Features
- Identify and remove `node_modules` directories.
- Optionally perform an assessment before deletion to understand the size impact.
- Remove directories recursively and forcefully.

## How to Use
1. Open PowerShell.
2. Navigate to the directory containing the Node Sweeper script.
3. Run the script with the desired path parameter:

Follow the prompts to decide whether you want an assessment before deletion and to confirm deletion.

## Parameter
- **Path**: Specifies the path to the directory where you want to start searching for `node_modules` directories.

## Example
`Remove-NodeModules -Path "C:\Users\15616\OneDrive\Documents`

This will search for all the `node_modules` directories in the Documents directory and its subdirectories and delete them recursively.

## Features to Implement
- Also remove package-loc.json files
- Only delete files the have not been modified up to a certain time period