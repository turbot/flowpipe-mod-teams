pipeline "create_team" {
  description = "Create a new team."

  param "token" {
    type    = string
    default = var.token
  }

  param "team_name" {
    type = string
  }

  param "team_description" {
    type = string
  }

  param "privacy_setting" {
    type    = string
    default = "private" // or "public"
  }

  step "http" "create_team" {
    title  = "Create a new team"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      displayName         = param.team_name,
      description         = param.team_description,
      isFavoriteByDefault = false,
      visibility          = param.privacy_setting,
    })
  }

  output "id" {
    value = jsondecode(step.http.list_teams.response_body).value.id
  }
  output "response_body" {
    value = step.http.create_team.response_body
  }
  output "response_headers" {
    value = step.http.create_team.response_headers
  }
  output "status_code" {
    value = step.http.create_team.status_code
  }
}
