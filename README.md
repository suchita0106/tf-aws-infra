# Terraform AWS Infrastructure Setup

This project uses Terraform to provision and manage cloud infrastructure on AWS. Follow the steps below to initialize Terraform, validate the configuration, and deploy or destroy your infrastructure.

## Quickstart

### Prerequisites
1. Install the AWS CLI.

2. Configure AWS credentials using the following command:
   ```
   aws configure --profile=<profile-name>
   ```
   You will be prompted to provide:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region name
   - Default output format

3. Ensure that Terraform is installed.


### Steps to Set Up the Infrastructure

#### 1. Create `.tfvars` File
Create a `<profile>.tfvars` file, which contains variables specific to your environment, such as AWS region, VPC configurations, etc.

#### 2. Format Terraform Code
Ensure your Terraform configuration files are properly formatted:
```
terraform fmt -check -recursive
```

#### 3. Initialize Terraform
Before running any Terraform commands, initialize the project to download the required provider plugins:
```
terraform init
```

#### 4. Validate the Terraform Configuration
Check whether your configuration is valid:
```
terraform validate
```

#### 5. Plan Your Cloud Infrastructure
Before applying any changes, generate an execution plan to preview the actions Terraform will take:
```
terraform plan -var-file=<profile>.tfvars
```

#### 6. Apply the Terraform Configuration
To create the resources defined in your Terraform configuration, run the following command:
```
terraform apply -var-file=<profile>.tfvars
```
Confirm with `yes` when prompted.

#### 7. Destroy the Terraform-managed Infrastructure
To tear down the resources created by Terraform, use the destroy command:
```
terraform destroy -var-file=<profile>.tfvars
```
Confirm with `yes` when prompted.

#### 8. Import certificate for demo using aws cli
Execute below command; change the file path accordingly:
```
aws acm import-certificate --profile=demo --certificate fileb://Certificate.pem \
      --certificate-chain fileb://CertificateChain.pem \
      --private-key fileb://PrivateKey.pem
```
Where,

The PEM-encoded certificate is stored in a file named Certificate.pem.

The PEM-encoded certificate chain is stored in a file named CertificateChain.pem.

The PEM-encoded, unencrypted private key is stored in a file named PrivateKey.pem.

If you have SSL certificate configured through mailgun, you can get the certificate and the certificate chain in a zip file after issuance of the certificate. The private key is generated while signing the CSR.

Additional Info: https://docs.aws.amazon.com/acm/latest/userguide/import-certificate-api-cli.html#import-certificate-cli