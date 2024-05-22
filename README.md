# Infrastructure

![Tech](https://github.com/g-loot/infra-terragrunt/workflows/Tech/badge.svg)

This repository creates and updates infrastructure (such as folders, projects, DBs, kubernetes, etc) in GCP.

**Need a new service?** Make a pull request!

## Dev notes

**Pull Request getting rejected due to formatting?** Run the following in the root folder of the repository:

``` bash
docker run --rm -v `pwd`/terragrunt:/apps \
alpine/terragrunt:1.0.0 \
bash -c "terraform fmt -recursive && terragrunt hclfmt"
```

## Folder structure

The folder structure in this repository aims to mirror the structure in GCP. Below is a sample of the structure.

``` text
live
    tech
        _folder
        dev
            _folder
            gnog
                _project
                kubernetes
                    cluster
                    services
                        bi-pipeline
                        flux
                        single-round-service
                        ...
            static-hosting
                _folder
                static-hosting-project
                    _project
                    ...
        performance-test
            _project
            kubernetes
            ...

    dev-old (deprecated, will be removed in the future)
        core
            ...
        service
            ...
    prod-old (deprecated, will be removed in the future)
        core
            ...
        service
            ...
modules
    gcp
        database
            sql
            bigquery
            ...
        network
            vpc
            dns
            ...
        kubernetes
            cluster
            namespace
            service
            ...
        project
        ...
    gloot
        iam
            gloot-service-account
```
## DB Patterns

## Instance type DEV

Min: db-f1-micro (0.7 vCPU 0.6 gb ram) db-g1-small (0.7 vCPU 1.7gb ram)

Max: db-custom-1-4096 ( 1 vCPU 4GB ram)

Single-zone


## Instance type PROD

Min: db-custom-1-4096 ( 1 vCPU 4GB ram)

Max: db-n1-standard-4  ( 4 vCPU 15GB ram)

## Note: If need increase for PROD,  just open PR
