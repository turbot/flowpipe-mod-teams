pipeline "list_chats" {
  title       = "List Chats"
  description = "List Chats."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  step "http" "list_chats" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/chats"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "chats" {
    value       = step.http.list_chats.response_body
    description = "Chats details."
  }
}
