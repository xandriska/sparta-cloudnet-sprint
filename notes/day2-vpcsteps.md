# Step-by-step instructions on how to provision two EC2 instances - an app and a database - with secure network settings.

## Making a VPC on AWS Console

- The VPC will need a CIDR block. 10.0.0.0/16 (Everything inside starts with 10.0., then the other 2 spots are open.)

- Inside the VPC we will have 2 subnets.

  - A public subnet. CIDR block 10.0.2.0/24 (Everything inside starts with 10.0.2., then the last one is open.)

  - A private subnet. CIDR block 10.0.3.0/24

- The public subnet will need a security group and a route table that communicates with the router and the internet gateway.

- The private subnet will have its own security group with a default route table to allow the private subnet to receive information from the router/internet/public domain (including the public subnet, i.e. our app).

![alt text](<Screenshot from 2025-11-25 11-53-26.png>)

## Making a VPC - step by step.

- In AWS, search "VPC" to find the VPC resource dashboard.

- Click the 'Create VPC' button.

- Click 'VPC only.'

- Give it a name. It's good to name it according to a convention or to show its relation to a certain project.

- Give it a CIDR block range. In our case 10.0.0.0/16, rather than the smaller 24.

- No IPv6 CIDR block.

- Tenancy: 'Dedicated' costs more and is more secure yet still public. We'll use default.

- Encryption control: not needed now.

![alt text](<Screenshot from 2025-11-25 15-27-01.png>)

- Click 'Create VPC'.

The VPC now exists, but it has nothing in it. We want some subnets to separate our public resources/instances from our private ones.

## Making subnets - step by step.

- Now go to 'subnets' on the left hand side menu.

- click 'Create subnet'.

- It will ask what VPC to use to house this subnet. Find the one we just made.

- Under Settings, name the subnet, select the availability zone (any is fine) and add the CIDR block. First let's make the public subnet, so when we name it, include 'public' somewhere, e.g. 'se-georgina-public-subnet'. The availability zone can be any that pop up as an option, but it can be sensible to put different subnets in different AZs. The CIDR block will be 10.0.2.0/24.

- We can add another subnet here before creating. Follow the same process for the private subnet, but include 'private' in the name, and under CIDR block, put '10.0.3.0/24'. Again, you can put the private subnet in a different AZ, for resilience.

- Now click 'create subnet' to create the subnets.

![alt text](<Screenshot from 2025-11-25 15-38-33-1.png>)

![alt text](<Screenshot from 2025-11-25 15-39-21.png>)

## Making and attaching an internet gateway.

- Now we need an internet gateway. This is an option on the left hand side menu again from VPC dashboard. Then go to 'create internet gateway'.

- Click green 'attach VPC' button that pops up, select our VPC, and attach.

- Now we shall make route tables. There is already a 'default' route table which should work on our PRIVATE subnet. But for the public subnet that will house our app, we need a public route table.

- Go to 'route tables', 'create route tables', name the table according to convention (it's for the public subnet remember!) and associate it with our VPC.

- Under the 'subnet associations' tab, click 'edit subnet associations'.

- Associate the public route table with the public subnet.

- This just duplicates the default settings, so now we need to edit the route. In the Actions drop-down, click "edit route".

- Then add the route. It's '0.0.0.0/0' for general internet, so we can use that CIDR block. The target should be the internet gateway we just created.

---

## Deploying a Mongo DB database in a private subnet.

- Begin the process of launching an instance by going to the EC2 dashboard and clicking the orange 'Launch instance' button.

- Name the instance according to convention or project.

- For the purposes of this guide, we assume that we have access to an AMI (Amazon Machine Image) with a Mongo DB database already installed. Under the Machine Image header, choose the custom one we've prepared earlier.

- Use an established key-pair that is associated with a .pem file that is stored locally and given correct permissions.

- Under network settings, we'll need to launch this instance in our just-created VPC, so choose it from the drop-down.

- Now under subnets, our own just-created subnets should appear. Here we want to choose the private one.

- Make sure the auto-assign public IP option is set to Disable. We don't want to automatically assign a public IP to the database instance, because we want it to stay private and prevent public access.

- Under security groups, click 'create security group'. Name it according to convention.

- Under the SG rules, leave SSH as is. Then add a new Custom group, and change the port number to 27017.

- Change the source to '10.0.2.0/24'. That allows our own public subnet (therefore our app) to access the DB instance, but doesn't allow access from just any public IP.

- Click 'launch instance.'

![alt text](<Screenshot from 2025-11-25 15-52-38.png>)

![alt text](<Screenshot from 2025-11-25 15-53-14.png>)

## Deploying a Node.js app instance in the public subnet.

- Launch another instance, and this time include 'app' somewhere in the name so we can differentiate it from the DB.

- For the purposes of this guide, we assume that we have access to an AMI (Amazon Machine Image) with a Node app already installed. Under the Machine Image header, choose the custom one we've prepared earlier.

- Use an established key-pair that is associated with a .pem file that is stored locally and given correct permissions.

- This time our network settings should be:

- Again, use the VPC we've just created.

- Use the public subnet this time.

- Change the auto-assign IP address option to Enable. Now that we're launching a public app instance, assigning it a public IP is fine.

- We still want the normal SSH rule.

- Add a new group rule to allow HTTP traffic on port 80. HTTP is under 'type'. Source can be 0.0.0.0/0.

![alt text](<Screenshot from 2025-11-25 15-56-16.png>)

![alt text](<Screenshot from 2025-11-25 15-56-36.png>)

---

## Deploying the app with the database.

- To deploy the app and database together, we can either manually input commands to the terminal by logging in using SSH, or we can use 'user data'. To use SSH, first launch the instance. Using User Data will require one more step before launching.

### SSH:

- When the app instance is launched, click on the instance information and click 'Connect.' Make sure .pem is selected, and then copy the terminal command provided.

- In the terminal, navigate to the /.ssh folder.

- Paste the command that AWS provided. If the instance was launched from a machine image, as per these instructions, we'll need to chane the IP address in the command from "root@..." to "ubuntu@...".

- This should connect us to the instance. From here we can input the commands necessary to start up the app.

## Leveraging the 'user data' form to automate deployment of the app.

- Under 'Advanced settings,' in the 'user data' form at the bottom of the screen, we can write a script containing deployment commands that AWS will run upon launching the instance. Here is an example using the commands necessary to launch the Sparta test app and placeholder database.

#!/bin/bash

sleep 20

cd /home/ubuntu

cd se-app-deployment-files/nodejs20-se-test-app-2025/app

export DB_HOST=mongodb://<IP of DB here>:27017/posts

node seeds/seed.js

sudo npm install

pm2 start app.js
