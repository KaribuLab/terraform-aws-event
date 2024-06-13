terraform {
  backend "s3" {}
}

resource "aws_sns_topic" "event" {
  count = length(var.topics)
  name = "${var.topics[count.index]}${var.fifo_queue ? ".fifo" : ""}"
  delivery_policy = var.delivery_policy
  fifo_topic = var.fifo_queue
  tags = var.common_tags
}

resource "aws_sqs_queue" "event_dlq" {
  count = length(var.topics)
  name = "${var.topics[count.index]}-dlq${var.fifo_queue ? ".fifo" : ""}"
  fifo_queue = var.fifo_queue
  tags = var.common_tags
}

resource "aws_sqs_queue" "event" {
  count = length(var.topics)
  name = "${var.topics[count.index]}${var.fifo_queue ? ".fifo" : ""}"
  fifo_queue = var.fifo_queue
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.event_dlq[count.index].arn
    maxReceiveCount = var.max_receive_count
  })
  tags = var.common_tags
}

resource "aws_sns_topic_subscription" "event" {
  count = length(var.topics)
  topic_arn = aws_sns_topic.event[count.index].arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.event[count.index].arn
}

resource "aws_sqs_queue_policy" "event" {
  count = length(var.topics)
  queue_url = aws_sqs_queue.event[count.index].id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "Allow-SNS-Event",
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.event[count.index].arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.event[count.index].arn
          }
        }
      }
    ]
  })
}