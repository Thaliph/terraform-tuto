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
gcloud auth application-default login --no-launch-browser
```


<walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/setup_project.sh">
    check script
</walkthrough-editor-open-file>

```bash
./setup_project.sh <walkthrough-project-name/>
```
**TIPS :** don't forget to change `PROJECT_ID` with the one you will use
## Basics
Summary
- deploy resource
- use variable
- destroy resource
- format our terraform
- try the console
- import some resource
- configure backend
## Deploy resource

See the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">
    configuration
</walkthrough-editor-open-file> of your network and the instance then it is time to **deploy** it!

First, go to the working_dir repo
```bash
cd working_dir
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

You can see your Compute Engine (https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>)  and your Virtual Private Network (https://console.cloud.google.com/networking/networks/list?referrer=search&project=<walkthrough-project-name/>)

## Use variable
See the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">
    configuration
</walkthrough-editor-open-file> of your network and the instance then it is time to **deploy** it!

First, go to the working_dir repo
```bash
cd working_dir
```
***

Time to use the file `variables.tf` and create `terraform.tfvars`!

```bash
touch terraform.tfvars
```

In the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">
    main.tf
</walkthrough-editor-open-file> file, let's change the resource google_compute_network as below :

```tf
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}
```

Change the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/variables.tf">
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
    filePath="cloudshell_open/terraform-tuto/working_dir/terraform.tfvars">
    terraform.tfvars
</walkthrough-editor-open-file> 

```tf
vpc_name = "custom-vpc-network"
```

***

You can notice that the plan won't change anything; we have the same configuration than before.

## Destroy resource
First, go to the working_dir repo
```bash
cd working_dir
```
***

Let's try the destroy command!
```bash
terraform destroy
```

You can see your Compute Engine (https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>)  and your Virtual Private Network (https://console.cloud.google.com/networking/networks/list?referrer=search&project=<walkthrough-project-name/>) has been destroyed.
## Format our terraform
First, go to the working_dir repo
```bash
cd working_dir
```
***
Make some choas in our file :
```bash
find . -type f -name "main.tf" -exec sed -i "s/ /   /g" {} +   
```

Check the modification in the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">
    configuration
</walkthrough-editor-open-file> file... Unreadable!

You can try the fmt commande
```bash
terraform fmt
```

Check the modification in the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">
    configuration
</walkthrough-editor-open-file> file... Beautiful!
## Try the console
First, go to the working_dir repo
```bash
cd working_dir
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
First, go to the working_dir repo
```bash
cd working_dir
```
and create a resource manually (https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>) that you will name `test-instance-1` and deploy it in `europe-west1-b`
***

Add a new `google_compute_instance` in <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">
    main.tf
</walkthrough-editor-open-file>

```tf
resource "google_compute_instance" "by-hand" {}
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
}
```

and apply it
```bash
terraform apply
```

Terraform is now managing the instance

**REMOVE THE RESOURCE google_compute_instance.by-hand from `main.tf`**
## Configure backend
First, create a bucket to be used as your backend
```bash
./setup_bucket.sh <walkthrough-project-name/> | bash
```

and go to the working_dir repo
```bash
cd working_dir
```
***

Create a new file `backend.tf` and fill it with :
```bash
echo "terraform {            
  backend \"gcs\" {
    bucket  = \"$BUCKET_NAME\"
    prefix  = \"terraform/state\"

  }
}
" > backend.tf
```
**Notice :** `BUCKET_NAME` is define in the <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/setup_bucket.sh">
    setup script
</walkthrough-editor-open-file>

You can see that a <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/setup_bucket.sh">
    `backend.tf`
</walkthrough-editor-open-file> file has been created with a bucket (https://console.cloud.google.com/storage/browser?referrer=search&project=<walkthrough-project-name/>&prefix=) in your GCP project


Now is time to initialize terraform since we have change our backend
```bash
terraform init
```

output :
```bash
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "gcs" backend. No existing state was found in the newly
  configured "gcs" backend. Do you want to copy this state to the new "gcs"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
```

Now you can go to your bucket to see your state in `terraform/state/` or directly by using the gsutil tool

```bash
gsutil cp gs://$BUCKET_NAME/terraform/state/default.tfstate .      
cat default.tfstate   
```

**Notice :** If you have press `yes`, the state is copied and the `cat` command will show your actual state.

To clean your folder : 
```bash
rm -rf .terraform*
rm -rf *.tfstate*
```

## Advance
Summary
- create a module
- use expression
- compare remote state datasource with data source
## Create a module
First, go to the working_dir repo
```bash
cd working_dir
```
***

Create a new folder `modules/backend`
```bash
mkdir modules
mkdir modules/backend
```

Move your `main.tf`, `outputs.tf` and `variables.tf` in it
```bash
for file in  "main.tf" "outputs.tf" "variables.tf"
do
    mv $file modules/backend
done
```

Create a variable for the `machine_type` of your google_compute_instance resource
```bash
find . -type f -name "main.tf" -exec sed -i "s/machine_type.*/machine_type = var\.instance_type/g" {} +
echo "
variable \"instance_type\" {
  type        = string
  description = \"Machine type e.g. e2-medium or custom-NUMBER_OF_CPUS-AMOUNT_OF_MEMORY_MB\"
}
"  >> modules/backend/variables.tf
```

In the root project, create a `main.tf` and create a module named `backend`.
It has a `./modules/backend` source, `f1-micro` as `instance_type`.

```bash
touch main.tf
echo "module \"backend\" {
  source        = \"./modules/backend\"
  instance_type = \"f1-micro\"
}
" > main.tf
```

**Notice :** We could specify `vpc_name` in our `backend` module but the variable has a <walkthrough-editor-open-file
    filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/versions.tf">
    default value
</walkthrough-editor-open-file>

**Tips :** you can use the command `fmt` with the option `-recursive` to format folders too :
```bash
terraform fmt -recursive
```

Now, we have to execute the `init` command because we added a `module`
```bash
terraform init
```

and we can see what it will do with and apply the change
```bash
terraform apply
```

**Tips :** we are destroying and creating a resource with the same name (network). It might fail, so, just re-apply if needed

We can use outputs to have information about our resources.
Let's try to get the `internal ip` used by our compute instance.

1. get the network_id from the <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/outputs.tf">module backend</walkthrough-editor-open-file>
```bash
echo "output \"network_ip\" {
  value = resource.google_compute_instance.default.network_interface.0.network_ip
}" > modules/backend/outputs.tf
```

2. Create an `outputs.tf` file in the root project add show the value network_ip from the `backend` module
```bash
touch outputs.tf
echo "output \"network_ip\" {
  value = module.backend.network_ip
}" > outputs.tf
```

3. Now, you can apply :
```bash
terraform apply
```
You can see a new line in the console that look like this:
```bash
Outputs:

network_ip = "X.X.X.X"
```
## Use expression
First, go to the working_dir repo
```bash
cd working_dir
```

and destroy your infra
```bash
terraform destroy
```
***

The goal is to create two google_instance_compute with a `for_each`
* In <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/main.tf">modules/backend/main.tf</walkthrough-editor-open-file> file add a `for_each = var.instance_type` parameter in a resource block 
* Replace `machine_type = var.instance_type` by `machine_type = each.value`
* Replace `name = “instance-1”` by `name = “instance-${each.key}”`
* In <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/variables.tf">modules/backend/variables.tf</walkthrough-editor-open-file> change `type=string` into `type=map`
* In <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">main.tf</walkthrough-editor-open-file> in root project replace `instance_type = “f1-micro”` by `instance_type = var.machine_list`
* In <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/variables.tf">varibales.tf</walkthrough-editor-open-file> define a `machine_list` variable which is a map type variable
* In <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/terraform.tfvars">terraform.tfvars</walkthrough-editor-open-file> define the value of instance_list: `instance_list = {“dev” = “f1-micro”, “prod” = “n1-standard-2”}`
* Change outputs to correct values

***

Correction :
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/main.tf">modules/backend/main.tf</walkthrough-editor-open-file>
```tf
resource "google_compute_instance" "default" {
  for_each                  = var.instance_type
  name                      = "instance-1-${each.key}"
  machine_type              = each.value
  zone                      = "europe-west1-b"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = "default"

    access_config {
      // Ephemeral IP
    }
  }
}
```
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/variables.tf">modules/backend/variables.tf</walkthrough-editor-open-file>
```tf
variable "instance_type"{
  type = map
}

variable "vpc_name"{
  type = string
  description = "The name of my custom vpc network"
  default = "custom-vpc"
}
```
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/modules/backend/outputs.tf">modules/backend/outputs.tf</walkthrough-editor-open-file>
```tf
output "network_ips"{
  value       = [ for instance in google_compute_instance.default :  instance.network_interface.0.network_ip ]
}
```
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/main.tf">main.tf</walkthrough-editor-open-file>
```tf
module "server"{
  source = "./modules/backend"
  instance_type = var.machine_list
}
```
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/variables.tf">variables.tf</walkthrough-editor-open-file>
```tf
variable "machine_list"{
  type = map
  description = "A map of different type of machine for dev and prod environment"
}
```
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/terraform.tfvars">terraform.tfvars</walkthrough-editor-open-file>
```tf
machine_list = {
  "dev"  = "f1-micro",
  "prod" = "n1-standard-2"
}
```
- <walkthrough-editor-open-file filePath="cloudshell_open/terraform-tuto/working_dir/outputs.tf">outputs.tf</walkthrough-editor-open-file>
```tf
output "network_ips"{
  value       = module.backend.network_ips
}
```

***

You can apply to create two instances. You will have a new output with a list of ips.

```bash
terraform apply
```

See you dev and prod VMs in : https://console.cloud.google.com/compute/instances?project=<walkthrough-project-name/>

## Compare remote state datasource with data source
TODO
## Automation    
- deploy cloudbuild
- use pre-commit & SAST tools
# Deploy cloudbuild

<walkthrough-enable-apis apis="cloudbuild.googleapis.com sourcerepo.googleapis.com">Activate cloudbuild & sourcerepo</walkthrough-enable-apis>

Create a git repo
```bash
gcloud source repos create my-iac
```

Clone a git repo
```bash
gcloud source repos clone my-iac
```
Move your `working_dir` to you git repo

```bash
for i in $(ls working_dir)
do
    mv working_dir/$i my-iac/
done
```


# Use pre-commit & SAST tools
## Félicitations !

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

C’est terminé !