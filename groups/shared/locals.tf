locals {


  secrets = data.vault_generic_secret.secrets.data

  # ----------------------------------------------------------------------------

  ssh_public_key = base64decode(local.secrets.ssh_public_key_base64)

  # ----------------------------------------------------------------------------

  debug = {}

}
