output "debug" {
  value = var.debug ? {
    debug = local.debug
  } : {}
}
