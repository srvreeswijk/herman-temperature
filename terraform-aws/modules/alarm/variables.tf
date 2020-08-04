variable "things" {
  type = map(object({
    name      = string
    treshold  = number
    snsTopic  = string
  }))
}