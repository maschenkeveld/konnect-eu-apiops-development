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