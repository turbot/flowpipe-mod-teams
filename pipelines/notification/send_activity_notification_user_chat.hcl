// usage: flowpipe pipeline run send_activity_notification_user_chat --pipeline-arg "activity_type=taskCreated" --pipeline-arg "chat_id=abc-21eda32-3fqaq-32fwef-f32vewsd" --pipeline-arg "message=Hello World" --pipeline-arg "recipient_user_id=abc-21eda32-3fqaq-32fwef-f32vewsd" --pipeline-arg "topic_value=Hello World" --pipeline-arg "token=abc-21eda32-3fqaq-32fwef-f32vewsd" --pipeline-arg "template_parameters=[{\"name\":\"string\",\"value\":\"string\"}]" --pipeline-arg "topic_source=string" --pipeline-arg "preview_text_content=Hello"

pipeline "send_activity_notification_user_chat" {
  description = "Send an activity notification to a user in a chat."

  param "token" {
    type    = string
    default = var.token
  }
  param "activity_type" {
    type = string
  }
  param "chain_id" {
    type    = number
    default = ""
  }
  param "chat_id" {
    type = string
  }
  param "message" {
    type = string
  }
  param "preview_text_content_type" {
    type    = string
    default = "text"
  }
  param "preview_text_content" {
    type = string
  }
  param "recipient_user_id" {
    type = string
  }
  param "template_parameters" {
    type = list
  }
  param "topic_source" {
    type    = string
    default = "text"
  }
  param "topic_value" {
    type = string
  }


  step "http" "send_activity_notification_user_chat" {
    title  = "Sends an activity notification to a user in a chat"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/sendActivityNotification"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      {
        topic = {
          source = param.topic_source,
          value  = param.topic_value
        },
        activityType = param.activity_type,
        chainId      = param.chain_id,
        previewText = {
          contentType = param.preview_text_content_type,
          content     = param.preview_text_content,
        },
        recipient = {
          "@odata.type" = "microsoft.graph.aadUserNotificationRecipient",
          userId        = param.recipient_user_id,
        },
        templateParameters = jsondecode(param.template_parameters),
      }
    })
  }

  output "response_body" {
    value = step.http.send_activity_notification_user_chat.response_body
  }
  output "response_headers" {
    value = step.http.send_activity_notification_user_chat.response_headers
  }
  output "status_code" {
    value = step.http.send_activity_notification_user_chat.status_code
  }
}
