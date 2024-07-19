resource "aws_sns_topic" "books_sold" {
  name       = "books-sold-topic"
  fifo_topic = false

  tags = {
    Name        = "My topic of books sold"
    Environment = "Dev"
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.books_sold.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
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

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "939645320583",
      ]
    }

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
