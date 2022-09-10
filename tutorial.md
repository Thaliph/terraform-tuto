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


<walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/setup_project.sh">
    check script
</walkthrough-editor-open-file>

```bash
./setup_project.sh <walkthrough-project-name/>
```
**TIPS :** don't forget to change `PROJECT_ID` with the one you will use
## Deploy resource

See the<walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    configuration
</walkthrough-editor-open-file> of your network and the instance then it is time to **deploy** it!

First, go to the basic repo
```bash
cd basic
```

***

Initialize the basic working directory
```bash
terraform init
```

Verify the content of the directory
```bash
terraform validate
```

Check what terraform wants to do
```bash
terraform plan
```

Apply your change
```bash
terraform apply
```

> you can re-use the plan command to see if terraform wants to make any new changes

## Use variable
See the<walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    configuration
</walkthrough-editor-open-file> of your network and the instance then it is time to **deploy** it!

First, go to the basic repo
```bash
cd basic
```
***
## Destroy resource
First, go to the basic repo
```bash
cd basic
```
***
## Format our terraform
First, go to the basic repo
```bash
cd basic
```
***
Make some choas in our file :
```bash
find . -type f -name "main.tf" -exec sed -i "s/ /   /g" {} +   
```

Check the modification in the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    configuration
</walkthrough-editor-open-file> file... Unreadable!

You can try the fmt commande
```bash
terraform fmt
```

Check the modification in the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    configuration
</walkthrough-editor-open-file> file... Beautiful!
## Try the console
## Import some resource
## Configure backend

## Félicitations !

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

C’est terminé !