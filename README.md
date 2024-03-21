# Deploying Static React Application on AWS using Terraform

This project demonstrates how to deploy a simple React application to AWS using Terraform. The application is a basic "Hello World" example, showcasing the integration of AWS services like S3 and CloudFront for hosting static web applications.

<div>
    <a href="https://www.loom.com/share/6d6c154d5b64448ab5739fb85ee3de19">
      <p>Demo: React App Deployment on AWS with terraform</p>
    </a>
    <a href="https://www.loom.com/share/6d6c154d5b64448ab5739fb85ee3de19">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6d6c154d5b64448ab5739fb85ee3de19-with-play.gif">
    </a>
</div>

## Project Structure

- `src/`: Contains the React application source files.
- `build/`: Build directory generated after running `npm run build`.
- `terraform/`: Contains Terraform files for AWS deployment.
- `NOTES.md`: Additional notes about the project.
- `README.md`: Documentation for the project.

## Prerequisites

- Node.js and npm
- AWS CLI configured with necessary permissions
- Terraform

## Setup and Deployment

Before running the terraform code ensure you remove the terraform block from s3.tf to avoid using remote state.
```
terraform {
  backend "s3" {
    bucket = "kubernetes-takemetoprod"  # Your S3 bucket name
    key    = "react-aws-terraform-tf-state/terraform.tfstate"  # Path to the state file
    region = "us-east-1"  # Your AWS region
  }
}
```

1. **Install Dependencies**: Run `npm install` in the project directory.
2. **Build the React App**: Execute `npm run build` to create a build directory.
3. **Initialize Terraform**: Navigate to the `terraform/` directory and run `terraform init`.
4. **Apply Terraform Plan**: Execute `terraform apply` to deploy resources on AWS.
5. **Upload Build to S3**: Use the AWS CLI to upload the contents of the `build/` directory to the S3 bucket.
```
aws s3 cp build s3://<bucket_name> --recursive --acl public-read
```
6. **Access Application**: The application should now be accessible via the CloudFront URL.

## Contributing

Feel free to fork this repository and submit pull requests for any improvements or fixes.

## License

This project is open-sourced under the MIT License.

