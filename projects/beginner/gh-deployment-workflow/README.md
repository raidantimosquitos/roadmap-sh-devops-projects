# GitHub Pages Deployment

Write a simple GitHub Actions workflow to deploy a static website to GitHub Pages. This is my implementation of [roadmap.sh](https://roadmap.sh/projects/github-actions-deployment-workflow).


You can access the GitHub pages in the following link: [https://raidantimosquitos.github.io/github-actions-deployment-workflow](https://raidantimosquitos.github.io/github-actions-deployment-workflow])


## Table of contents
- [Requirements](#Requirements)
- [Usage](#Usage)
- [Annex](#Annex)

## Requirements
This repository assumes you are using an Ubuntu/Debian OS, and have `git` installed.

## Usage
The functioning of the system is as follows:
    1. The `main` branch is where all the source code of the static website is stored and where it is edited and worked on.
    2. When changes are pushed to the `main` branch, the static website directory is transferred to the `gh-deployment-workflow` branch.
    3. The `gh-deployment-workflow` branch will serve the website content to GitHub pages.

You must store the `deploy.yml` file inside a hidden folder `.github/workflows`, this must be located in the root directory of your repository.


## Annex
The GitHub actions used in my `deploy.yml` script are the following:
    - [Upload artifact](https://github.com/actions/upload-artifact): to upload static website content from `main` branch.
    - [Checkout](https://github.com/actions/checkout): to checkout the `gh-deployment-workflow` branch.
    - [Download artifact](https://github.com/actions/download-artifact): to download the static website content into `gh-deployment-workflow` branch.

Git configuration setup, directory checks and commits/push are all manually defined actions in the `deploy.yml` file.
