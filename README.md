# Kubernetes Terraform

## Quickstart

```
cd ubuntu/instance/test
terraform init
terraform apply
```

## How to create a new deployment

- copy `_template` to a directory of your choice (i.e. `ubuntu`)
- remove all resources that you do not require (use syntax highlighting to fix whatever breaks afterwards)
  - `deployment.tf` / `statefulset.tf` / `daemonset.tf` (keep one)
  - `ingress.tf`
  - `pvc.tf`
  - `configEnv.tf`
  - `configVolume.tf`
  - `secretEnv.tf`
  - `secretVolume.tf`
- replace all occurrences of `TODO`
- create as many `instances` as you require (i.e. `dev`, `test`, `staging`, `production`)
- make non-generic adjustments to your resources (i.e. add `command` to `deployment.tf`)

## General 

It is not recommended to take this repository as is as a base for all of your terraform kubernetes code!
This repository is merely to provide a general approach that can be used to define a structure fitting your use case.


## Recommendations

- check the inputs and outputs of `_data` and adjust them to fit your use case (i.e. replace linkerd annotations with istio)
- check the code in `_template` and adjust it to fit your use case (i.e. make resource requests/limits variable)
- keep each directory as a separate repository and either use the repository (including release tag) as module reference, or write a [gitfile](https://github.com/Bobonium/gitfile) instead
- whenever you make a change to your `_template` run a diff over all repositories and apply the structure change in all of your repositories

## Naming Conventions

The code in here makes use of 3 different conventions to make it easier to differentiate between the meaning of that particular part.
Main reason for that is, that terraform normally recommends snake_case, but kubernetes resources do not support snake_case.

snake_case:
 - terraform internal structures (i.e. resource identifiers)
 
kebab-case:
 - kubernetes resource names (i.e. namespace name)

camelCase: 
 - everything that's not kubernetes or terraform relevant (i.e. terraform resource names)
 