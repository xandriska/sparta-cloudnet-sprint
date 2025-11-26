## MAKING A VPC

- The VPC will have a CIDR block. 10.0.0.0/16 (everything inside starts with 10.0., then the other 2 spots are open.)

- Inside the VPC we will have 2 subnets.

  - Public subnet. CIDR block (smaller range) 10.0.2.0/24 (everything inside starts with 10.0.2., then the last one is open.)

  - Private subnet. CIDR block 10.0.3.0/24

- the public subnet will have a security group and a route table that communicates with the router and the internet gateway.

- the private subnet will have its own security group with a default route table to allow the private subnet to receive information from the router/internet/public domain (including the public subnet, i.e. our app)

![alt text](<Screenshot from 2025-11-25 11-53-26.png>)

## STEP BY STEP.

- In AWS, search "VPC" to find the VPC resource dashboard.

- Create VPC button

- Click 'VPC only.' (no shortcuts!)

- give it a name.

- give it a CIDR block range. in our case 10.0.0.0/16 rather than the smaller 24.

- no IPv6 CIDR block.

- tenancy. dedicated costs more and is more secure yet still public. we'll use default.

- encryption control - not needed now.

![alt text](<Screenshot from 2025-11-25 15-27-01.png>)

- click 'Create VPC'

The VPC now exists, but it has nothing in it. We want some subnets to separate our public resources/instances from our private ones.

- Now go to 'subnets' on the left hand side menu.

- click 'create subnet'

- it will ask what VPC to use to house this subnet. find the one we just made.

- under Settings, name the subnet, select the availability zone and add the CIDR block. first let's make the public subnet, so put this under 'name', choose an appropriate AZ, then enter the CIDR block we want to use.

- we can add another subnet here before creating. follow the same process for the private subnet. you can put the private subnet in a different AZ for resilience.

- now click 'create subnet' to create the subnets.

![alt text](<Screenshot from 2025-11-25 15-38-33-1.png>)

![alt text](<Screenshot from 2025-11-25 15-39-21.png>)

- now we need an internet gateway. this is an option on the left hand side menu again from VPC dashboard, then go to 'create internet gateway'

- click green attach vpc button, select our VPC and attach

- now we shall make route tables. there is already a 'default' route table which should work on our PRIVATE subnet. but we will need to make a public route table.

- go to route tables, create route tables, name it (the public one remember) and associate it with the VPC.

- subnet associations tab, then edit subnet associations

- associate the RT with the public subnet.

- this just dupes the default. so now: edit routes in actions

- then add the route. 0.0.0.0/0 for general internet, and give it our internet gateway as a target.

---

## DEPLOYING A DATABASE IN A PRIVATE SUBNET

- launch a database instance. BUT we need some new network settings:

- for the private subnet, under network settings, we need our own just-created VPC.

- now under subnets, our own subnets should appear. here we want to choose the private one.

- make sure public IP is set to Disable. we don't want it to assign a public IP to the database instance.

- under security groups, click 'create security group'. name it according to convention.

- under the SG rules, leave SSH as is. then add a new group, and change the port to 27107.

- change the source to 10.0.2.0/24. that allows our own public subnet to access the DB instance, but doesn't allow access from any public IP. it's more specific/secure.

- click launch instance.

NOTE: WHEN CONNECTING TO THIS INSTANCE VIA SSH, CHANGE 'ROOT' TO 'UBUNTU' ON THE COMMAND LINE!! CAUSE WE'RE LAUNCHING FROM AN IMAGE BABES. (but right now we can't actually connect to this instance via SSH because it's not accessible, it's in a private subnet. BUT it is accessible from an instance in the PUBLIC subnet we've created because we've given THAT thing access in the security group.)

![alt text](<Screenshot from 2025-11-25 15-52-38.png>)

![alt text](<Screenshot from 2025-11-25 15-53-14.png>)

## DEPLOYING APP INSTANCE IN PUBLIC SUBNET

- launch an app instance. new network settings:

- use the VPC we've created.

- use the public subnet.

- change the auto-assign IP address to Enable.

- we still want the normal SSH rule.

- add a new group rule to allow HTTP traffic on port 80. HTTP is under 'type'. source can be 0.0.0.0/0.

![alt text](<Screenshot from 2025-11-25 15-56-16.png>)

![alt text](<Screenshot from 2025-11-25 15-56-36.png>)

---

## USER DATA FOR THE INSTANCES:

sleep 15

cd /home/ubuntu

mine: cd se-app-deployment-files/nodejs20-se-test-app-2025/app

luke's: cd se-sparta-test-app/app

- export env variables for db here:

export DB_HOST=mongodb://<IP of DB here>:27017/posts

node seeds/seed.js

sudo npm install

pm2 start app.js

sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo chown mongodb:mongodb /tmp/mongodb-27017.sock  
sudo service mongod restart

App SG:

SSH (port 22) --> 0.0.0.0/0
HTTP (port 80) --> 0.0.0.0/0

DB SG:
SSH (port 22) --> 0.0.0.0/0
MongoDB (port 27017) --> 0.0.0.0/0 or app IP
