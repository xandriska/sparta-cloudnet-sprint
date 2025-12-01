# Sparta Education - Cloud Networking Sprint

This repo contains notes, guidance and example project files following Sparta Education's trainer-led course on Cloud Networking in November '25.

Work on the 5-day course involved provisioning EC2 instances from machine images - a Node.js app and a MongoDB database - and manually setting up networking resources on AWS Console to deploy the instances securely. The notes serve as documentation and a instruction guide for this process, including VPCs, subnets, route tables and security groups.

This repo also contains a Terraform file which allows for the deployment of the EC2s with the aforementioned network setup. More specifically, this setup entailed two subnets, one public for the app and one private for the database, and both of these contained in a VPC with an Internet Gateway, with all security groups and route tables properly attached.

This Terraform file is not an example of best practice, and was written as part of a self-study segment of the course. It works for the purpose of this project, but it was not produced under guidance of a trainer and there is likely much room for improvement.
