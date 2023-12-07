pipeline "get_current_user" {
  title       = "Get Current User"
  description = "Retrieve the properties and relationships of current user."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  step "http" "get_current_user" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }

  output "current_user" {
    description = "Current User details."
    value       = step.http.get_current_user.response_body
  }
}
