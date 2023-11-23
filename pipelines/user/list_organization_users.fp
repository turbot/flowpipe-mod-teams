pipeline "list_organization_users" {
  title       = "List Organization Users"
  description = "Retrieve the list of organization users."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  step "http" "list_organization_users" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "users" {
    value       = step.http.list_organization_users.response_body
    description = "List of organization users."
  }
}
