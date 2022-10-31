/***************************************************
  Provider Google
****************************************************/

terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    google = {
      version = ">= 4.20.0, < 5"
      source  = "hashicorp/google"
    }
  }
}