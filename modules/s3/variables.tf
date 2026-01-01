variable "bucket_name" {
  type = string
}

variable "files_to_upload" {
  type = list(object({
    key  = string
    path = string
  }))
}