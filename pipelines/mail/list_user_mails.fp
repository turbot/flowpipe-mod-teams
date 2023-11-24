pipeline "list_user_mails" {
  title       = "List User Mails"
  description = "List all messages of a user."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "user_id" {
    type        = string
    description = local.user_id_param_description
  }

  step "http" "list_user_mails" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "mails" {
    value       = step.http.list_user_mails.response_body
    description = "List of all emails."
  }
}
