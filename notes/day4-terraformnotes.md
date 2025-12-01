## terraform - variables

Terraform variables allow us to define variables in a separate file and reference these in the rest of our project, rather than hard-code every long/complex/sensitive ID, key pair, ARN, etc. To do this we make a variable.tf file, and define each variable as described in the terraform docs.

--

It's possible to have different vars files for different types of instances. If we're starting with an instance of a node app, our vars in the variables.tf file will reflect that. But we might want to deploy a different type of instance, for example a database. With this command:

terraform plan -var-file="db_instance.tfvars"

... we can just swap out our vars file for a different one and it will map the new variables to each var name in the main terraform resources. So an "instance_ami" variable will then reference the database AMI and not the nodeapp AMI.
