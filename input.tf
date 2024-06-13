variable topics {
  type        = list(string)
  description = "The name of the SNS topics"
}

variable fifo_queue {
  type        = bool
  description = "FIFO queue"
}

variable delivery_policy {
  type        = string
  description = "The delivery policy for the SNS topic"
}

variable common_tags {
  type        = map(string)
  description = "The common tags for the SNS topic"
}

variable max_receive_count {
  type        = number
  default = 3
  description = "The maximum number of times a message can be received"
}