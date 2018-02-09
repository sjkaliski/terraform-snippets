provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "site" {
  bucket = "${var.domain}"

  website {
    index_document = "index.html"
  }

  force_destroy = false
}

resource "aws_s3_bucket_policy" "site" {
  bucket = "${aws_s3_bucket.site.id}"
  policy = "${data.aws_iam_policy_document.site.json}"
}

data "aws_iam_policy_document" "site" {
  statement = {
    sid = "PublicRead"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "${aws_s3_bucket.site.arn}/*",
    ]
  }
}

resource "aws_s3_bucket" "www-site" {
  bucket = "www.${var.domain}"

  website {
    redirect_all_requests_to = "${aws_s3_bucket.site.id}"
  }

  force_destroy = false
}

resource "aws_route53_record" "site" {
  zone_id = "${var.zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.site.website_domain}"
    zone_id                = "${aws_s3_bucket.site.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www-site" {
  zone_id = "${var.zone_id}"
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.site.website_domain}"
    zone_id                = "${aws_s3_bucket.site.hosted_zone_id}"
    evaluate_target_health = false
  }
}
