// usage: flowpipe pipeline run update_chat_message --pipeline-arg chat_id="19:4paze140-abcd-40kb-9c2d-e4b4379ee6c1_944a8e14-1h3t-48c6-bob9-6e93612f6c2b@unq.gbl.spaces" --pipeline-arg message_id="1698751207618" --pipeline-arg message="Hello World returns"
pipeline "update_chat_message" {
  title       = "Update Chat Message"
  description = "Update a chat message."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "chat_id" {
    type        = string
    description = "The unique identifier for the chat."
  }

  param "message" {
    type        = string
    description = "The updated message to send."
  }

  param "message_id" {
    type        = string
    description = "The unique identifier for the message."
  }

  step "http" "update_chat_message" {
    method = "patch"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/messages/${param.message_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      body = {
        content = param.message
      }
    })
  }
}
