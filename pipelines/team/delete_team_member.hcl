pipeline "delete_team_member" {
  description = "Delete a member from an existing team."

  param "token" {
    type    = string
    default = var.token
  }

  param "team_id" {
    type    = string
    default = "fa3dfaa9-6658-43fa-be18-298b8df03d2f"
  }

  param "team_membership_id" {
    type    = string
    default = "MCMjMSMjZmRkYjNkMDQtYWQ2MS00YjBjLWFmNWEtMjkzMmEyNzdkMmJjIyNmYTNkZmFhOS02NjU4LTQzZmEtYmUxOC0yOThiOGRmMDNkMmYjIzk0NGE4ZTE0LTdhNmYtNDhjNi04ODA1LTZlOTM2MTJmNmMyYg=="
  }

  step "http" "delete_team_member" {
    title  = "Deletes a member from an exisiting team"
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members/${param.team_membership_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "response_body" {
    value = step.http.delete_team_member.response_body
  }
  output "response_headers" {
    value = step.http.delete_team_member.response_headers
  }
  output "status_code" {
    value = step.http.delete_team_member.status_code
  }
}
