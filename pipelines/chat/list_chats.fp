pipeline "list_chats" {
  title       = "List Chats"
  description = "Retrieve the list of chats that the user is part of."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  step "http" "list_chats" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/chats?$top=50"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
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
