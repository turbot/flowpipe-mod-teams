pipeline "create_user" {
  title       = "Create User"
  description = "Create a new user."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "display_name" {
    type        = string
    description = "The name to display in the address book for the user."
  }

  param "account_enabled" {
    type        = bool
    description = "If the account is enabled then true; otherwise, false."
  }

  param "mail_nickname" {
    type        = string
    description = "The mail alias for the user."
  }

  param "user_principal_name" {
    type        = string
    description = "The user principal name (someuser@contoso.com)."
  }

  param "password" {
    type        = string
    description = "The password for the user."
  }

  step "http" "create_user" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/users"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName       = param.display_name
      userPrincipalName = param.user_principal_name
      mailNickname      = param.mail_nickname
      accountEnabled    = param.account_enabled
      passwordProfile = {
        password = param.password
      },
    })
  }

  output "create_user" {
    value       = step.http.create_user.response_body
    description = "The created user."
  }
}
