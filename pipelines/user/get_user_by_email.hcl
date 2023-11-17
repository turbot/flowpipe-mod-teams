pipeline "get_user_by_email" {
  title       = "Get detail of the User"
  description = "Retrieve user details by email."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "user_email" {
    type        = string
    description = "Email of the user."
  }

  step "http" "get_user_by_email" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_email}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "user" {
    value       = step.http.get_user_by_email.response_body
    description = "User detail."
  }
}
