# Terraform Tutorial
## Introduction
In this tutorial we will see :
- basics
    - deploy resource
    - use variable
    - destroy resource
    - format our terraform
    - try the console
    - import some resource
    - configure backend
- advance
    - create a module
    - use expression
    - compare remote state datasource with data source
- automation    
    - deploy cloudbuild
    - use pre-commit & SAST tools

## Use a project

<walkthrough-project-setup></walkthrough-project-setup>

First we need to authenticate and access our project
```bash
gcloud auth login --no-launch-browser
```

```bash
./setup_project.sh <walkthrough-project-name/>
```
**TIPS :** don't forget to change `PROJECT_ID` with the one you will use
## Deploy resource

<walkthrough-editor-select-regex filePath="basic/main.tf">TEXT</walkthrough-editor-select-regex>

See the configuration of your network then it is time to **deploy** it!

```bash
terraform init
```

```bash
terraform validate
```

```bash
terraform plan
```

```bash
terraform apply
```

## Use variable
## Destroy resource
## Format our terraform
## Try the console
## Import some resource
## Configure backend

## Félicitations !

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

C’est terminé !