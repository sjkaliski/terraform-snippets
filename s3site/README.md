# s3site

This module creates a static site hosted on AWS S3.

## Usage

```
module "s3site" {
  source = "github.com/sjkaliski/terraform-snippets//s3site

  region  = "us-east-1"
  domain  = "mysite.com"
  zone_id = "route53_zone_id"
}
``` 
