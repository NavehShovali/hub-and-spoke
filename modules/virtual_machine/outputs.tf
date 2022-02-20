output "id" {
  value = local.virtual_machine == null ? null : local.virtual_machine.id
}

output "name" {
  value = local.virtual_machine == null ? null : local.virtual_machine.name
}

output "object" {
  value = local.virtual_machine
}
