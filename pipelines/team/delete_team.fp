pipeline "delete_team" {
  title       = "Delete Team"
  description = "Delete a team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  step "http" "delete_team" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/groups/${param.team_id}"

    request_headers = {
      Content-Type  = "application/json"
      cache-control = "no-cache"
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
