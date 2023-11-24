pipeline "get_email" {
  title       = "Get Email"
  description = "Retrieve the properties and relationships of an email."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "user_id" {
    type        = string
    description = local.user_id_param_description
  }

  param "message_id" {
    type        = string
    description = "The email message ID."
  }

  step "http" "get_email" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/messages/${param.message_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "get_mail" {
    value = step.http.get_email.response_body
  }
}
