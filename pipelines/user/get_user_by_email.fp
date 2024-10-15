pipeline "get_user_by_email" {
  title       = "Get User by Email"
  description = "Retrieve the properties and relationships of user."

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
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
      Authorization = "Bearer ${param.conn.access_token}"
    }

    error {
      ignore = true
    }
  }

  output "user" {
    description = "The user details."
    value       = step.http.get_user_by_email.response_body
  }

  # Used to handle 404 in sample pipeline
  output "status_code" {
    description = "The status code."
    value       = step.http.get_user_by_email.status_code
  }
}
