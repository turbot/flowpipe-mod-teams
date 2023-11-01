pipeline "get_current_user" {
  title       = "Get Current User"
  description = "Retrieve the properties and relationships of user object."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  step "http" "get_current_user" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "current_user" {
    value       = step.http.get_current_user.response_body
    description = "Current User details."
  }
}
