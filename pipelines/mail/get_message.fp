pipeline "get_message" {
  title       = "Get Message"
  description = "Retrieve the properties and relationships of a message object."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "user_id" {
    type        = string
    description = local.user_id_param_description
  }

  param "message_id" {
    type        = string
    description = "The email message ID."
  }

  step "http" "get_message" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/messages/${param.message_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }

  output "message" {
    description = "The email message."
    value       = step.http.get_message.response_body
  }
}
