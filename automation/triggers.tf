module "triggers" {
  source = "./modules/triggers"

  for_each = {
    "master" = {
        name = "branch-main"
        description = "trigger for the production environnement"
        branch_name = "^main$"
    }
    "pr-to-main" = {
        name = "pr-to-main"
        description = "trigger for pull request to main branch"
        branch_name = "^main$"
    }
    "feature-branch" = {
        name = "default"
        description = "trigger for feature branch"
        branch_name = "^feature/.*"
    }
  }
  name = each.value.name
  description = each.value.description
  branch_name = each.value.branch_name
  repo_name            = "my-iac"
}

locals {
  cloudbuild_sa = format("%s@cloudbuild.gserviceaccount.com", data.google_project.project.number, )
}

data "google_project" "project" {
}

resource "google_project_iam_member" "sa_rights" {
  role    = "roles/compute.admin"
  member  = "serviceAccount:${local.cloudbuild_sa}"
}