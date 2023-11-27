variable "access_token" {
  description = "The Microsoft personal security access_token to authenticate to the Microsoft graph APIs."
  type        = string
  # TODO: Add once supported
  #sensitive  = true
}

variable "team_id" {
  description = "The unique identifier of the Team."
  type        = string
}