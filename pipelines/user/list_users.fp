pipeline "list_users" {
  title       = "List Users"
  description = "Retrieve the list of users."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  step "http" "list_users" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users?$top=999"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    loop {
      until = lookup(result.response_body, "@odata.nextLink", null) == null
      url   = lookup(result.response_body, "@odata.nextLink", "")
    }
  }

  output "users" {
    description = "List of users."
    value       = flatten([for entry in step.http.list_users : entry.response_body.value])
  }
}
