// pipeline "chat_create" {
//   description = "Create a new team."

//   param "token" {
//     type    = string
//     default = var.token
//   }

//   param "roles" {
//     type = list(string)
//   }

//   param "user_id" {
//     type = string
//   }

//   step "http" "chat_create" {
//     title  = "Create a new chat"
//     method = "post"
//     url    = "https://graph.microsoft.com/v1.0/chats"

//     request_headers = {
//       Content-Type  = "application/json"
//       Authorization = "Bearer ${param.token}"
//     }

//     request_body = jsonencode({
//       "@odata.type" = "#microsoft.graph.aadUserConversationMember",
//       roles         = param.roles,
//       "user@odata.bind" : "https://graph.microsoft.com/v1.0/users('${param.user_id}')",
//     })
//   }

//   output "response_body" {
//     value = step.http.chat_create.response_body
//   }
//   output "response_headers" {
//     value = step.http.chat_create.response_headers
//   }
//   output "status_code" {
//     value = step.http.chat_create.status_code
//   }
// }
