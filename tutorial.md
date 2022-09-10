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

See the <walkthrough-editor-open-file
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

You can see your [Compute Engine](https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>)  and your [Virtual Private Network](https://console.cloud.google.com/networking/networks/list?referrer=search&project=<walkthrough-project-name/>)

## Use variable
See the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    configuration
</walkthrough-editor-open-file> of your network and the instance then it is time to **deploy** it!

First, go to the basic repo
```bash
cd basic
```
***

Time to use the file `variables.tf` and create `terraform.tfvars`!

```bash
touch terraform.tfvars
```

In the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    main.tf
</walkthrough-editor-open-file> file, let's change the resource google_compute_network as below :

```tf
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}
```

Change the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/variables.tf">
    variables.tf
</walkthrough-editor-open-file> and add a vpc name

```tf
variable "vpc_name"{
  type = string
  description = "The name of my custom vpc network"
  default = "custom-vpc"
}
```

and specify the value of `vpc_name` in the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/terraform.tfvars">
    terraform.tfvars
</walkthrough-editor-open-file> 

```tf
vpc_name = "custom-vpc-network"
```

***

You can notice that the plan won't change anything; we have the same configuration than before.

## Destroy resource
First, go to the basic repo
```bash
cd basic
```
***

Let's try the destroy command!
```bash
terraform destroy
```

You can see your [Compute Engine](https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>)  and your [Virtual Private Network](https://console.cloud.google.com/networking/networks/list?referrer=search&project=<walkthrough-project-name/>) has been destroyed.
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
First, go to the basic repo
```bash
cd basic
```
and redeploy your infrastructrue
```bash
terraform init
terraform apply
```
***
Time to play with the console mode :

1. check our variable
```bash
echo 'var.vpc_name' | terraform console
```
2. check the compute engine labels
```bash
echo 'resource.google_compute_instance.default.labels' | terraform console
```
3. check the network name
```bash
echo 'resource.google_compute_network.vpc_network.name' | terraform console
```
## Import some resource
First, go to the basic repo
```bash
cd basic
```
and [create a resource manually](https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>) that you will name `test-instance-1` and deploy it in `europe-west1-b`
***

Add a new `google_compute_instance` in <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/basic/main.tf">
    main.tf
</walkthrough-editor-open-file>

```tf
resource "google_compute_instance" "by-hand" {)
```

**Notice :** See that we change the `label name`; it is now `by-hand`

Let's import the resource :
```bash
terraform import google_compute_instance.by-hand <walkthrough-project-name/>/europe-west1-b/test-instance-1
```
***
Let's make some changes :
```tf
resource "google_compute_instance" "by-hand" {
  machine_type = "e2-medium"
  allow_stopping_for_update = true
  name = "test-instance-1"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.custom_subnet.self_link

    access_config {
      //   Ephemeral   IP
    }
  }
}
```

and apply it
```bash
terraform apply
```

If you have time, you can try to set `allow_stopping_for_update` to false and change the `machine_type` to `f1-micro`
```tf
resource "google_compute_instance" "by-hand" {
  machine_type = "f1-micro"
  allow_stopping_for_update = false
  name = "test-instance-1"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.custom_subnet.self_link

    access_config {
      //   Ephemeral   IP
    }
  }
```

and apply it
```bash
terraform apply
```

Terraform is now managing the instance
## Configure backend

## Félicitations !

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

C’est terminé !