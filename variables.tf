variable "KPAT" {
  type    = string
  default = ""
}

variable "konnect_region" {
  type    = string
  default = "eu"
}

variable "zones" {
  type    = list(string)
  default = ["mink-zone-a", "mink-zone-b"]
}

variable "HCV_ROOT_TOKEN" {
  type    = string
  default = ""
}

variable "write_to_openbao" {
  type        = bool
  default     = true
  description = "Write connection/portal details to OpenBao."
}

variable "write_to_file" {
  type        = bool
  default     = true
  description = "Write connection/portal details to a local JSON file."
}

variable "local_output_file" {
  type        = string
  default     = "connection-details.json"
  description = "Filename (relative to the stack) for the local details file."
}