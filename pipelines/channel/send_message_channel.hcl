pipeline "send_message_channel" {
  description = "Send a message to a channel or chat."

  param "token" {
    type    = string
    default = var.token
  }

  param "team_id" {
    type = string
  }

  param "channel_id" {
    type = string
  }

  param "message" {
    type = string
  }

  step "http" "send_message_channel" {
    title  = "Send a message to Microsoft Teams channel"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      body = {
        content = "${param.message}"
      }
    })
  }

  output "id" {
    value = jsondecode(step.http.send_message_channel.response_body).id
  }
  output "response_body" {
    value = step.http.send_message_channel.response_body
  }
  output "response_headers" {
    value = step.http.send_message_channel.response_headers
  }
  output "status_code" {
    value = step.http.send_message_channel.status_code
  }
}
