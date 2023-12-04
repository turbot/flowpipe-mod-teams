pipeline "list_chats" {
  title       = "List Chats"
  description = "Retrieve the list of chats that the user is part of."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  step "http" "list_chats" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/chats?$top=50"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    loop {
      until = lookup(result.response_body, "@odata.nextLink", null) == null
      url   = lookup(result.response_body, "@odata.nextLink", "")
    }
  }

  output "chats" {
    description = "List of chats."
    value       = flatten([for entry in step.http.list_chats : entry.response_body.value])
  }
}
