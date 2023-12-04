pipeline "delete_group" {
  title       = "Delete Group"
  description = "Delete a group."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
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
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
