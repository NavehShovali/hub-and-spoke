output "id" {
  description = "The ID of the created virtual machine"
  value       = local.virtual_machine == null ? null : local.virtual_machine.id
}

output "name" {
  description = "The name of the created virtual machine"
  value       = local.virtual_machine == null ? null : local.virtual_machine.name
}

output "object" {
  description = "The data object of the created virtual machine"
  value       = local.virtual_machine
}
