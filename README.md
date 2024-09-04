# nextjs-app

This project deploys an example NextJS application as docker container in an AWS EC2 instance.

Includes.

- Application code for a hello-world application from [vercel](https://github.com/vercel/next.js/tree/canary/examples)
- Dockerfile for building the docker image
- Github action workflow to 
    - Build the docker image
    - Push the docker image to ECR
    - Scan the vulnerabilities using [Trivy](https://aquasecurity.github.io/trivy/v0.50/)
    - Deploy the docker image in EC2 instance
- Terraform code to provision the infra resources..
