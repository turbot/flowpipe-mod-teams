pipeline "list_team" {
  description = "Retrieve a list of all teams."

  param "token" {
    type    = string
    default = var.token
  }

  step "http" "list_team" {
    title  = "Retrieve a list of teams"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/joinedTeams"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "response_body" {
    value = jsondecode(step.http.list_team.response_body).value
  }
  output "response_headers" {
    value = step.http.list_team.response_headers
  }
  output "status_code" {
    value = step.http.list_team.status_code
  }
}
