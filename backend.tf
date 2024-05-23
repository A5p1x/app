terraform {
  backend "s3" {
    bucket         = "petstefantfbucket" # Replace with your bucket name
    key            = "terraform.tfstate"     # Adjust the path as needed
    region         = "us-east-1"                        # or your preferred region
    encrypt        = true
  }
}
