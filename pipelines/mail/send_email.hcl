//Usage flowpipe pipeline run send_email --pipeline-arg subject="Email Subject" --pipeline-arg content="Body" --pipeline-arg cc_email='["test@test.com"]' --pi
// peline-arg to_email='["test@turbot.com", "test@gmail.com"]'
pipeline "send_email" {
  title       = "Send Email"
  description = "Send email to recipient(s)."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "subject" {
    type        = string
    description = "The subject of the email."
  }

  param "content" {
    type        = string
    description = "The content of the email."
  }

  param "to_email" {
    type        = list(string)
    description = "The email-id(s) of the primary receipient(s)."
  }

  // TO DO MAKING OPTIONAL IT FAILS Flowpipe v0.1.0-beta.202311140126
  // param "cc_email" {
  //   type        = list(string)
  //   description = "The email-id(s) of the receipient(s) in CC."
  //   optional    = true
  // }

  step "http" "send_email" {
    title  = "Send Mail"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/me/sendMail"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      "message" : {
        "subject" : "${param.subject}",
        "body" : {
          "contentType" : "Text",
          "content" : "${param.content}"
        },
        "toRecipients" : [
          for email in param.to_email : {
            "emailAddress" : {
              "address" : email
            }
          }
        ]
        // "ccRecipients" : [
        //   for cc_email in param.cc_email : {
        //     "emailAddress" : {
        //       "address" : cc_email
        //     }
        //   }
        // ]
      }
    })
  }

}
