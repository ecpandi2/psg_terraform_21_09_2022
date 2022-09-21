/* terrform version   - 1.2.x(latest)
   aws version        - 4.26.x(latest)
   kubernetes version - 2.x(latest)
   helm               - 2.x(latest)
*/
terraform {
  required_providers {
    aws = {
      version = "~>4.26.0"
    }
    kubernetes = {
      version = "~>2.0"
    }
    helm = {
      version = "~>2.0"
    }
  }
  required_version = "~> 1.2.6"
}