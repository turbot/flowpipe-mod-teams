
pipeline "create_chat" {
  title       = "Create Chat"
  description = "Create a new one-on-one or group chat."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "chat_type" {
    type        = string
    description = "Specifies the type of chat."
  }

  param "topic" {
    type        = string
    description = local.chat_topic_param_description
    optional    = true
  }

  param "user_ids" {
    type        = list(string)
    description = "List of conversation members that should be added. One-on-one chat requires minimum of 2 users including the current user."
    optional    = true
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
