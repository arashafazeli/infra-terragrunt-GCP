#!/usr/bin/env bash

find ../terragrunt -type d -name "*.terragrunt-cache" -exec rm -rf {} \;
find ../terragrunt -type d -name "*.terraform" -exec rm -rf {} \;
find ../terragrunt -type f -name "*.terraform.lock.hcl" -exec rm -rf {} \;
