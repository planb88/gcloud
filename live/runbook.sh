#!/usr/bin/env bash

#terragrunt hclfmt
#terragrunt run-all plan --terragrunt-json-out-dir  ../.plan

terragrunt run-all plan --terragrunt-out-dir ../.plan --terragrunt-json-out-dir ../.plan
