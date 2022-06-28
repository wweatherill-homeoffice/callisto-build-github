terraform {
  backend "s3" {
    bucket = "ho-callisto-dev"
    key    = "terraform/build/callisto-build-github"
  }
}

# Configure the GitHub Provider
provider "github" {
  # owner = "UKHomeOffice" Set using environment variable GITHUB_OWNER as we can't use terraform variables in providers
  # token = "" Set using environment variable GITHUB_TOKEN
}



data "github_team" "callisto" {
  slug = "callisto"
}

module "repository" {
  source   = "./modules/repository"
  for_each = local.repository_configs

  name   = each.key
  config = each.value
}

resource "github_team_repository" "callisto_repos" {
  for_each   = module.repository
  team_id    = data.github_team.callisto.id
  repository = each.value.name
  permission = "push"
}


