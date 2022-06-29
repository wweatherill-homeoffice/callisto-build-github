locals {
  checks = {
    drone = [
      "continuous-integration/drone/pr",
      "continuous-integration/drone/push"
    ],
    code_analysis = [
      "SonarCloud"
    ]
  }

  repositories = {
    "callisto-test-1" : {
      "checks" : concat(local.checks.drone, local.checks.code_analysis)
    },
    "callisto-test-2" : {
      "checks" : concat(local.checks.drone, local.checks.code_analysis)
    },
    "callisto-docs" : { }
  }
  repository_configs = {
    for k, v in local.repositories : k => {
      checks = try(v.checks, [])
    }
  }

}
