# Terraform AWS Event

This module establishes a streamlined architecture of components to facilitate data reception to an SNS Topic, which is subsequently read by an SQS Queue.

## Inputs

| Name              | Type         | Description                                                            | Required |
| ----------------- | ------------ | ---------------------------------------------------------------------- | -------- |
| topics            | list(string) | Name of SNS topics                                                     | yes      |
| delivery_policy   | string       | JSON delivery policy                                                   | yes      |
| max_receive_count | number       | The maximum number of times a message can be received **(default: 3)** | no       |
| fifo_queue        | bool         | Fifo queue                                                             | yes      |
| common_tags       | map(string)  | Common tags for components                                             | yes      |

## Outputs

| Name      | Type         | Description            |
| --------- | ------------ | ---------------------- |
| topic_arn | list(string) | List of SNS topics ARN |
| queue_arn | list(string) | List of SQS ARN        |