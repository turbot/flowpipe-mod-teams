pipeline "list_messages" {
  title       = "List Messages"
  description = "Get all the messages in a user's mailbox."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "user_id" {
    type        = string
    description = local.user_id_param_description
  }

  step "http" "list_messages" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/messages?$top=999"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    loop {
      until = lookup(result.response_body, "@odata.nextLink", null) == null
      url   = lookup(result.response_body, "@odata.nextLink", "")
    }
  }

  output "messages" {
    description = "List of all emails."
    value       = flatten([for entry in step.http.list_messages : entry.response_body.value])
  }
}
