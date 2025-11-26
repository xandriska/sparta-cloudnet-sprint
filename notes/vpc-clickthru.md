# Two-tier VPC setup

## VPC Setup

### Navigate to VPC

#### <span style="background-color:orange"><font color="blue">Create VPC</font></span>

- **Resource to create:** VPC only
- **Name tag:** se-morgan-2tier-vpc
- **IPv4 CIDR block:** IPv4 CIDR manual input
- **IPv4 CIDR:** 10.0.0.0/16
- **IPv6 CIDR block:** No IPv6 CIDR block
- **Tenancy:** Default
- **VPC encryption control:** None

#### <span style="background-color:orange"><font color="blue">Create VPC</font></span>

## Subnet Setup

#### Click "Subnets"

#### <span style="background-color:orange"><font color="blue">Create subnet</font></span>

- **VPC ID:** se-morgan-2tier-vpc
- **Subnet name:** se-morgan-public-subnet-1
- **Availability Zone:** eu-west-1a
- **IPv4 VPC CIDR block:** 10.0.0.0/16
- **IPv4 subnet CIDR block:** 10.0.2.0/24

#### <span style="background-color:white"><font color="blue">Add new subnet</font></span>

- **Subnet name:** se-morgan-private-subnet-1
- **Availability Zone:** eu-west-1b
- **IPv4 VPC CIDR block:** 10.0.0.0/16
- **IPv4 subnet CIDR block:** 10.0.3.0/24

#### <span style="background-color:orange"><font color="blue">Create subnet</font></span>

## Route table Setup

#### Click "Route tables"

#### <span style="background-color:orange"><font color="blue">Create route table</font></span>

- **Route table name:** se-morgan-2tier-vpc-public-rt
- **VPC:** se-morgan-2tier-vpc

#### <span style="background-color:orange"><font color="blue">Create route table</font></span>

#### Subnet associations (TAB)

- <span style="background-color:white"><font color="blue">**Edit subnet associations**</font></span>
- **Select:** se-morgan-public-subnet-1

#### <span style="background-color:orange"><font color="blue">Save associations</font></span>

## Internet Gateway Setup

#### Click "Internet gateways"

#### <span style="background-color:orange"><font color="blue">Create Internet gateway</font></span>

- **Internet gateway name:** se-morgan-2tier-vpc-ig

#### <span style="background-color:orange"><font color="blue">Create Internet gateway</font></span>

#### <span style="background-color:green"><font color="white">Attach to a VPC</font></span>

- **Available VPCs:** se-morgan-2tier-vpc

#### <span style="background-color:orange"><font color="blue">Attach Internet gateway</font></span>

### Route through Internet Gateway

#### Click "Route tables"

#### **Select:** se-morgan-2tier-vpc-public-rt

#### Routes (TAB)

<span style="background-color:white"><font color="blue">Edit routes</font></span>

- <span style="background-color:white"><font color="blue">Add route</font></span>

- **Destination:** 0.0.0.0/0
- **Target:** Internet Gateway
- **Select:** se-morgan-2tier-vpc-ig

#### <span style="background-color:orange"><font color="blue"> Save changes</font></span>

---

### **//Technically done, now time to check\\\\**

---

# Launch instance #1 (Private DB)

### Navigate to EC2

#### <span style="background-color:orange"><font color="blue"> Launch Instance </font></span>

- **Instance name:** se-morgan-db-private-sn
- **My AMIs:** se-morgan-mongodb-image-1
- **Key pair name:** se-morgan-cloud-networking
- **Network settings:** <span style="background-color:white"><font color="blue">Edit</font></span>
  - **VPC:** se-morgan-2tier-vpc
  - **Subnet:** se-morgan-private-subnet-1
  - **Auto-assign public IP:** Disable
  - **Create security group**
    - **Security group name:** se-morgan-mongodb-private-sg
    - **NB: Leave default ssh rule alone for testing**
    - <span style="background-color:white"><font color="blue">Add security group rule</font></span>
      - **Type:** Custon TCP
      - **Port range:** 27017
      - **Source:** 10.0.2.0/24 (Our public subnet can access)
      - **Description:** Public subnet instances

#### <span style="background-color:orange"><font color="blue"> Launch Instance </font></span>

---

# Launch instance #2 (Public App)

#### <span style="background-color:orange"><font color="blue"> Launch an instance </font></span>

- **Instance name:** se-morgan-app-public-sn
- **My AMIs:** se-morgan-node-app-image-1
- **Key pair name:** se-morgan-cloud-networking
- **Network settings:** <span style="background-color:white"><font color="blue">Edit</font></span>
  - **VPC:** se-morgan-2tier-vpc
  - **Subnet:** se-morgan-public-subnet-1
  - **Auto-assign public IP:** Enable
  - **Create security group**
    - **Security group name:** se-morgan-nodejs-public-sg
    - **NB: Leave default ssh rule alone for testing**
    - <span style="background-color:white"><font color="blue">Add security group rule</font></span>
      - **Type:** Custon TCP
      - **Port range:** 80
      - **Source:** 0.0.0.0/0 (The internet)
- **Advance details**
  - **User data:** user-data.sh

#### <span style="background-color:orange"><font color="blue"> Launch Instance </font></span>

---

Go to http://(ip-address)/posts where (ip-address) is replaced by the Public IPv4 address of your second instance (se-morgan-app-public-sn in this case).
