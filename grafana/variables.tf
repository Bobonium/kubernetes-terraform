variable "provisioningYml" {}
variable "datasourcesYml" {}
variable "dashboards" {
  type = map(map(string))
}