include "backend" {
  path = find_in_parent_folders("backend.hcl")
}

include "encryption" {
  path = find_in_parent_folders("encryption.hcl")
}

dependency "network" {
  config_path = "../network"
}

dependency "compute" {
  config_path = "../compute"
}

dependency "tls-wildcard" {
  config_path = "../tls-wildcard"
}

inputs = {
  dns_zone_name        = dependency.network.outputs.dns_zone_name
  service_name         = dependency.compute.outputs.service_name
  backend_services_id  = dependency.compute.outputs.backend_services_id
  certificate_id       = dependency.tls-wildcard.outputs.certificate_id
}

terraform {
  source = "${get_path_to_repo_root()}/modules/google-global-lb"
  before_hook "set_workspace" {
    commands = ["plan", "state", "apply", "destroy", "output"]
    execute  = ["tofu", "workspace", "select", "-or-create=true", get_env("TG_WORKSPACE", "default")]
  }
  extra_arguments "custom_vars" {
    commands  = get_terraform_commands_that_need_vars()
    arguments = ["-var-file=${get_repo_root()}/conf/${get_env("TG_WORKSPACE", "default")}/common.tfvars", ]
  }
}
