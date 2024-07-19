resource "aws_sns_topic" "books_sold" {
  name       = "books-sold-topic"
  fifo_topic = false

  tags = {
    Name        = "My topic of books sold"
    Environment = "Dev"
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.books_sold.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.books_sold.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sqs_queue" "books-sold-queue" {
  name = "books-sold-queue"
}

data "aws_iam_policy_document" "aws_sqs_queue_iam_policy_document" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.books-sold-queue.arn]
  }
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.books-sold-queue.id
  policy    = data.aws_iam_policy_document.aws_sqs_queue_iam_policy_document.json
}

resource "aws_sns_topic_subscription" "books_sold_sqs_target" {
  topic_arn = aws_sns_topic.books_sold.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.books-sold-queue.arn
}
