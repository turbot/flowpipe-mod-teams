pipeline "delete_group" {
  title       = "Delete Group"
  description = "Delete a group."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "id" {
    type        = string
    description = "The unique identifier of the group."
  }

  step "http" "delete_group" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/groups/${param.id}"

    request_headers = {
      Content-Type  = "application/json"
      cache-control = "no-cache"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }
}
