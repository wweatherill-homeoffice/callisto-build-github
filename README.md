# SCM - Repository creation and configuration

We wish to introduce standards for branch protection rules and repository configuration.
As there isn't currently support for applying this configuration across multiple
repositories, we have decided to apply the configuration through terraform to provide
consistency and to aid the detection of any drift in configuration that we wish to 
be consistent.

# Explicit inclusion

Over time, the team may be provided access to other repositories that they do not own.
Keeping this in mind, the choice was made that repositories would need to be explicitly
configured to have this configuration applied to them. This avoids this terraform
configuration from being mistakenly applied to other respositories that the team
were provided access to.

To include a repository it must be created first and then added to the configuration
in the repositories.tf file.

# Configuration

All variable configuration is currently held in the repositories.tf file. This currently
includes the repository name and the checks required on pull requests for the main branch.

As the configuration matures and different repositories are added we expect the checks
required to vary but to have commonality across similar repository types or CI/CD 
processes. Therefore the checks have been grouped and can be concated together to meet
the needs of the repository.

For example, if we had 2 repositories, 1 containing code and another that only publishes
documentation then both repositories would probably have CI/CD pipelines but only the
repository containing code may need to perform SAST. Therefore, the configuration may
look like this

```
repositories = {
    "hello-world-application" : {
      "checks" : concat(local.checks.drone, local.checks.code_analysis)
    },
    "documentation" : {
      "checks" : local.checks.drone
    }
  }
```

If you wish to configure branch protection to not require any checks that can be done by 
either omitting the `checks` property or by setting it to an empty array.

```
repositories = {
    "no-check" : {
      "checks" : []
    },
    "dont-check-me-either" : { }
  }
```


Need a pipeline that creates a plan and has a manual gate to review the plan and run it.
This pipeline should run on master and there should also be a scheduled task that runs
and checks that the plan produces no changes and sends a notification when there are changes.
this is to detect any drift where configuration may have been changed outside of terraform
