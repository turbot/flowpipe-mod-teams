// usage: 
// Create a group with self - helpful in test cases: flowpipe pipeline run create_chat --pipeline-arg chat_type="group" --pipeline-arg topic="wow such empty" 
// Create a group with multiple users: flowpipe pipeline run create_chat  --pipeline-arg chat_type="group" --pipeline-arg topic="meeting" --pipeline-arg user_ids='["10101010-aaaa-bbbb-cccc-999999999999", "10101010-aaaa-bbbb-cccc-999999999999"]'
// Create a oneOnOne with user: flowpipe pipeline run create_chat --pipeline-arg chat_type="oneOnOne" --pipeline-arg user_ids='["10101010-aaaa-bbbb-cccc-999999999999"]'
pipeline "create_chat" {
  title       = "Create Chat"
  description = "Create a new oneOnOne or group chat object."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "chat_type" {
    type        = string
    description = "Specifies the type of chat. Possible values are: group and oneOnOne."
  }

  param "topic" {
    type        = string
    optional    = true
    description = "The title of the chat. The chat title can be provided only if the chat is of group type."
  }

  param "user_ids" {
    type        = list(string)
    optional    = true
    description = "The unique identifier for the user."
  }

  step "pipeline" "get_current_user" {
    pipeline = pipeline.get_current_user
    args = {
      access_token = param.access_token
    }
  }

  step "http" "create_chat" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/chats"

    request_headers = {
      "Content-Type"  = "application/json"
      "Authorization" = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      "chatType" = param.chat_type,
      "topic"    = param.topic,
      "members" = concat([
        {
          "@odata.type"     = "#microsoft.graph.aadUserConversationMember",
          "roles"           = ["owner"],
          "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('${step.pipeline.get_current_user.output.current_user.id}')"
        }],
        param.user_ids != null ? [for user_id in param.user_ids : {
          "@odata.type"     = "#microsoft.graph.aadUserConversationMember",
          "roles"           = ["owner"],
          "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('${user_id}')"
        }] : []
      )
    })
  }

  output "chat" {
    value       = step.http.create_chat.response_body
    description = "Chat details."
  }
}
