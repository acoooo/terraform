policy_arn = [
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  "arn:aws:iam::aws:policy/CloudFrontReadOnlyAccess",
  "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
]

primary_vpc_cidr = "10.0.0.0/16"

secondary_vpc_cidr = "20.0.0.0/16"

primary_vpc_public_subnet_cidr = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

primary_vpc_private_subnet_cidr = [
  "10.0.4.0/24",
  "10.0.5.0/24",
  "10.0.6.0/24"
]

primary_vpc_database_subnet_cidr = [
  "10.0.7.0/24",
  "10.0.8.0/24",
  "10.0.9.0/24"
]

secondary_vpc_public_subnet_cidr = [
  "20.0.1.0/24",
  "20.0.2.0/24",
  "20.0.3.0/24"
]

secondary_vpc_private_subnet_cidr = [
  "20.0.4.0/24",
  "20.0.5.0/24",
  "20.0.6.0/24"
]

secondary_vpc_database_subnet_cidr = [
  "20.0.7.0/24",
  "20.0.8.0/24",
  "20.0.9.0/24"
]