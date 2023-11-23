pipeline "delete_email" {
  title       = "Delete Email"
  description = "Delete an email."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "user_id" {
    type        = string
    description = "The unique identifier for the user."
  }

  param "message_id" {
    type        = string
    description = "The email message ID which needs to be deleted."
  }

  step "http" "delete_email" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/messages/${param.message_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "deleted_mail" {
    value = step.http.delete_email.response_body
  }
}
