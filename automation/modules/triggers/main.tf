locals {
    yaml = yamldecode(file("./modules/triggers/${var.name}/cloudbuild.yaml"))
}

resource "google_cloudbuild_trigger" "trigger" {
    description    = var.description
    disabled       = false
    ignored_files  = []
    included_files = []
    name           = var.name
    project        = var.project_id
    substitutions  = {}
    tags           = []
    build {
        dynamic step {
          for_each = local.yaml.steps
          content {
              id = step.value.id
              name = step.value.name
              entrypoint = step.value.entrypoint
              args = step.value.args
          }
        }
    }
    
    timeouts {}

    trigger_template {
        invert_regex = true
        project_id   = var.project_id
        repo_name    = var.repo_name
        branch_name  = var.branch_name
    }
}