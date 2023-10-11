pipeline "create_channel" {
  description = "Create a new channel within an existing team."

  param "token" {
    type    = string
    default = var.token
  }

  param "team_id" {
    type = string
  }

  param "channel_name" {
    type = string
  }

  param "channel_description" {
    type = string
  }

  step "http" "create_channel" {
    title  = "Create a new channel"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      displayName = param.channel_name,
      description = param.channel_description
    })
  }


  output "id" {
    value = jsondecode(step.http.create_channel.response_body).id
  }
  output "response_body" {
    value = step.http.create_channel.response_body
  }
  output "response_headers" {
    value = step.http.create_channel.response_headers
  }
  output "status_code" {
    value = step.http.create_channel.status_code
  }
}
