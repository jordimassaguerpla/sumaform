module "client" {
  source = "../host"

  base_configuration = "${var.base_configuration}"
  name = "${var.name}"
  count = "${var.count}"
  use_unreleased_updates = "${var.use_unreleased_updates}"
  additional_repos = "${var.additional_repos}"
  additional_packages = "${var.additional_packages}"
  gpg_keys = "${var.gpg_keys}"
  ssh_key_path = "${var.ssh_key_path}"
  grains = <<EOF

version: ${var.version}
mirror: ${var.base_configuration["mirror"]}
server: ${var.server_configuration["hostname"]}
role: client
auto_register: ${var.auto_register}
testsuite: ${var.base_configuration["testsuite"]}

EOF

  // Provider-specific variables
  image = "${var.image}"
  flavor = "${var.flavor}"
  root_volume_size = "${var.root_volume_size}"
  floating_ips = "${var.floating_ips}"
}

output "configuration" {
  value = "${module.client.configuration}"
}
