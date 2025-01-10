include "backend" {
  path = find_in_parent_folders("backend.hcl")
}

include "encryption" {
  path = find_in_parent_folders("encryption.hcl")
}

inputs = {
  root_dns_zone_name = "simple-site1"
}

terraform {
  source = "${get_path_to_repo_root()}/modules/google-network"
  before_hook "set_workspace" {
    commands = ["plan", "state", "apply", "destroy", "output"]
    execute  = ["tofu", "workspace", "select", "-or-create=true", get_env("TG_WORKSPACE", "default")]
  }
  extra_arguments "custom_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_repo_root()}/conf/${get_env("TG_WORKSPACE", "default")}/common.tfvars",
      "-var-file=${get_repo_root()}/conf/${get_env("TG_WORKSPACE", "default")}/network.tfvars"
    ]
  }
}
