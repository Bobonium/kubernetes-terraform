variable "storageClassName" {}
variable "storageSize" {}

variable "storageAccessModes" {
  type = "list"

  default = [
    "ReadWriteOnce",
  ]
}
