pipeline "list_emails_by_user" {
  title       = "List Emails By User"
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

  step "http" "list_emails_by_user" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "mails" {
    value       = step.http.list_emails_by_user.response_body
    description = "List all messages."
  }
}
