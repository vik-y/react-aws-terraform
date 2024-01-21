# Deploying Static React Application on AWS using Terraform

This project demonstrates how to deploy a simple React application to AWS using Terraform. The application is a basic "Hello World" example, showcasing the integration of AWS services like S3 and CloudFront for hosting static web applications.

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

