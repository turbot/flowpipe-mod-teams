// usage: flowpipe pipeline run send_message_channel --pipeline-arg team_id="TEAM_ID" --pipeline-arg channel_id="CHANNEL_ID" --pipeline-arg message="MESSAGE"
pipeline "send_message_channel" {
  description = "Send a message to a channel."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "channel_id" {
    type        = string
    description = "The ID of the channel"
  }

  param "message" {
    type        = string
    description = "The message to send"
  }

  step "http" "send_message_channel" {
    title  = "Sends a message to a channel"
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
    value       = jsondecode(step.http.send_message_channel.response_body).id
    description = "The ID of the message"
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
