## WHAT IS A VPC?

VPC stands for Virtual Private Cloud. In contrast to the public cloud, i.e. AWS/Google/Azure standard resources that we've been using so far, a VPC is something
you can set up to reserve and cordon off cloud resources such as ec2, databases etc. This is done for multiple reasons.

- It's more secure: only systems that have the correct access information (security groups, ports, gateways, IPs etc) can interact with resources on the VPC,
  a bit like a "firewall" for your resources.

- We have more control: we can control traffic to the resources on the VPC more easily with IP ranges, subnets etc.

- We can still scale and add resources as we can with a public cloud.

## WHAT DOES A DEFAULT VPC LOOK LIKE?

A default VPC is a pre-configured, ready-to-use virtual private network that an AWS account receives in each region, which includes a public subnet in every Availability Zone, an internet gateway, a default security group, and a route table that directs traffic to the internet. It is designed for immediate use to launch instances, but it has a single, fixed CIDR range and does not have security best practices applied by default. Core components of a default VPC 
VPC: A single virtual private cloud in each region, with a CIDR block of \(172.31.0.0/16\).

## WHAT ARE THE CORE COMPONENTS?

VPC: A single virtual private cloud in each region, with a CIDR block of \(172.31.0.0/16\).

Subnets: A public subnet in each Availability Zone within the region, with a CIDR block of \(172.31.0.0/20\).

Internet Gateway: An internet gateway is automatically created and attached to the VPC, allowing for internet access.

Route Table: A main route table is configured to send all internet-bound traffic (\(0.0.0.0/0\)) to the internet gateway, making the subnets public.

Security Group: A default security group is created to control inbound and outbound traffic.

DNS: DNS settings are enabled to automatically assign public DNS hostnames to instances with public IP addresses and allow for DNS resolution through the Amazon-provided DNS server.

## PUBLIC IP VS PRIVATE IP

A public IP address is a unique, internet-wide identifier that allows devices to communicate globally, assigned by an internet service provider (ISP). A private IP address is for internal, local networks and is assigned by a router, making devices reachable only within that specific network and not directly from the internet. This means a home network's router has one public IP for all internet traffic, while each device inside gets its own private IP to communicate with the router and other local devices.

## IPV4 VS IPV6

IPv4 and IPv6 are both internet protocols, but they differ mainly in their address length, which affects the total number of available addresses and other features. IPv4 uses a 32-bit address, providing about 4.3 billion unique addresses, while IPv6 uses a 128-bit address, offering a virtually unlimited number of addresses. This massive increase in addresses allows IPv6 to include more efficient routing, built-in security (IPsec), and stateless auto-configuration, which are more cumbersome in IPv4.

## CIDR BLOCKS

- Classless Inter-Domain Routing

- smaller prefix = larger range.

- a range of IP addresses assigned to a certain task or traffic type.

CIDR blocks are groups of IP addresses that share a common network prefix and are represented using (CIDR) notation, such as 192.168.1.0/24. This notation specifies a network address followed by a slash and a number that indicates how many bits are static for the network portion of the address. A smaller number means a larger block with more IP addresses, while a larger number means a smaller block with fewer IP addresses.

## SUBNET MASKS

A subnet mask is a 32-bit number used to divide an IP address into its network and host portions. It is crucial for network communication, as it helps devices and routers determine whether a destination IP address is on the same local network or on a different one, guiding where to send data packets. The network portion identifies the network, while the host portion identifies a specific device on that network.

Function: A subnet mask works by using a sequence of ones for the network portion and zeros for the host portion. When a device's IP address is combined with its subnet mask, it can determine which part is the network address and which is the host address.

Routing: Based on this separation, a device can tell if it should send data to its default gateway for a remote network or if the destination is on its own local network.

Example: For an IP address like \(192.168.1.10\) with a subnet mask of \(255.255.255.0\), the first three octets (\(192.168.1\)) represent the network, and the last octet (\(10\)) represents the host.

Subnetting: Network administrators can use subnet masks to divide a single network into smaller, more manageable subnets, which improves organization and security.

## RESERVED IP ADDRESSES

Reserved IP address ranges are
blocks of IP addresses set aside for specific uses, with the most common ones being for private networks, loopback, and multicast. For IPv4, these include private ranges like 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16, which are used on internal networks and are not routable on the public internet. Other reserved ranges are for loopback addresses (127.0.0.0/8), link-local addresses (169.254.0.0/16), and multicast (224.0.0.0/8–239.0.0.0/8).

## WHAT IS NAT?

- 'NAT' - Network Address Translation - allows multiple devices on a private LAN to share a single public IP

- translates the private IP addresses as traffic leaves the network

- conserves number of IPv4 addresses

- masks internal network details, adding security

"NAT, or Network Address Translation, is a process that allows multiple devices on a private local network to share a single public IP address when connecting to the internet. By modifying IP address information in data packets, NAT translates private IP addresses to a public one as traffic leaves the network and translates the public address back to the correct private address for incoming responses. This conserves the limited number of public IPv4 addresses and adds a layer of security by masking internal network details from the outside world."

## PUBLIC VS PRIVATE SUBNETS?

- public subnet uses an 'internet gateway' - general use, public-facing resources, two-way routing

- private subnet uses NAT gateway - private use, more secure, resources not accessible externally, one-way routing

A public subnet is a subnet with a direct route to the internet via an Internet Gateway, allowing resources within it to be accessed from the public internet and to access it directly. In contrast, a private subnet lacks a direct route to the internet, meaning resources in it are not directly accessible from the outside but can still access the internet indirectly, typically through a NAT gateway.  
Public subnet

Internet connectivity: Has a direct route to an Internet Gateway.

Accessibility: Resources can be accessed directly from the public internet.

IP addresses: Resources often require a public IP address to communicate directly with the internet.

Typical use: Web servers, load balancers, and other publicly facing resources.

Private subnet

Internet connectivity: Does not have a direct route to the Internet Gateway.

Accessibility: Resources are shielded from direct internet access and cannot be accessed from the internet.
Internet access: Resources can initiate outbound connections to the internet through a NAT device (like a NAT Gateway).
IP addresses: Resources do not need a public IP address to communicate with the internet via a NAT device.
Typical use: Databases, application servers, and other internal resources that should not be publicly exposed.

## SUBNETS AND AZS?

Availability Zones (AZs) are isolated, physically separate locations within a region, while subnets are logical IP address ranges within a Virtual Private Cloud (VPC) that are tied to a single AZ. You place resources like servers into subnets, and the choice of subnet determines the AZ where the resource will be deployed. This structure is key for building highly available and fault-tolerant applications.

Relationship and best practices

    VPC: A VPC spans all the AZs in a region. You create subnets within the VPC and place those subnets in specific AZs.
    High availability: To create a highly available application, you should create subnets in multiple AZs and place your resources across them. For example, a public subnet in AZ-A and another in AZ-B for your web servers, and a private subnet in AZ-A and another in AZ-B for your database.

## NAT GATEWAY VS INTERNET GATEWAY

- analogy: a person in a private room/bedroom/jail wants to receive something from a public space, e.g. a package. the private room doesn't have access to the public domain,
- but the package can be delivered to the public domain and the private room can temporarily behave like the public domain (like opening a door) to receive the package.

An Internet Gateway (IGW) provides bidirectional internet access for public subnets, allowing instances to receive and send traffic initiated from the internet. A NAT Gateway provides outbound-only internet access for instances in private subnets, allowing them to connect to the internet without being directly reachable from it. A NAT Gateway uses an Internet Gateway to perform this outbound connection, and it is a chargeable service, while an Internet Gateway itself is free.

## HOW DO PUBLIC SUBNETS ACCESS THE INTERNET?

Via an internet gateway. A public subnet already has a public IP address, so they can access the internet directly via the internet gateway.

## WHY DO PRIVATE SUBNETS NEED NAT?

Private subnets need a NAT gateway to allow instances inside them to connect to the internet for outbound traffic, such as for software updates, while preventing unsolicited inbound connections from the internet. The NAT gateway acts as an intermediary, translating the private IP addresses of the instances to a public IP address so they can communicate outwards, but it blocks any attempts to initiate a connection back to them from the internet. This security design keeps critical resources like databases in private subnets without direct internet exposure.

## ARE THERE COST DIFFERENCES?

Yes - NAT gateways are a chargeable service, but internet gateways are free.

## DIFFERENT ARCHITECTURES?

## WHAT DOES A 'DEFAULT' ROUTE TABLE LOOK LIKE?

A default route table, also known as the main route table, is the default routing table automatically created with a virtual private cloud (VPC) or virtual network (VNet). It controls traffic for any subnet that is not explicitly associated with a custom route table. A key feature is the "local" route, which handles all communication within the VPC, while another route, often 0.0.0.0/0, sends traffic not matching any other specific rule to the internet gateway.

## WHAT IS LOCAL ROUTING?

Local routing is the process of routing packets to a router's own IP address, which is specified in the routing table with a
/32 subnet mask. It's a specific type of route that helps a router efficiently handle traffic sent to itself, and it is typically created automatically by the router when an interface is configured. This is different from "connected" routes, which handle traffic for a larger network that the router is directly connected to.

## WHAT IS 0.0.0.0/0 ROUTING?

The CIDR notation 0.0.0.0/0 defines an IP block containing all possible IP addresses. It is commonly used in routing to depict the default route as a destination subnet. It matches all addresses in the IPv4 address space and is present on most hosts, directed towards a local router.

## ROUTES TO NAT GATEWAY VS INTERNET GATEWAY

Routes to a NAT gateway are created by associating the gateway with a private subnet's route table, which directs all internet-bound traffic (0.0.0.0/0) to the NAT gateway instead of the default internet gateway. This is typically done by adding a new route to the private subnet's route table with a destination of 0.0.0.0/0 and the NAT gateway as the next hop.
How to route traffic through a NAT gateway

    Create a private subnet: This is where your instances will reside. They will not have direct internet access.
    Create a public subnet: This subnet will host the NAT gateway and has a route table with a route that points internet traffic to an internet gateway.
    Create and configure the NAT gateway: In the public subnet, create a NAT gateway and assign it an Elastic IP address.
    Modify the private subnet's route table:
        Navigate to the route table associated with the private subnet.
        Add a new route.
        Set the Destination to 0.0.0.0/0 (which represents all IPv4 internet traffic).
        Set the Target to your NAT gateway.
        Save the route.

Routes to an internet gateway are configured through route tables associated with a subnet. To grant a subnet internet access, you create a route in its associated route table with a destination of 0.0.0.0/0 (for all IPv4 traffic) or ::/0 (for all IPv6 traffic) and set the target to the internet gateway. This rule directs all traffic not specifically matched by other routes to the internet gateway.
Steps to configure a route

    Create or select a route table: Create a new route table or use an existing one and associate it with your public subnet.
    Add a route for internet access:
        Destination: Enter 0.0.0.0/0 for IPv4 or ::/0 for IPv6.
        Target: Select the internet gateway that you have attached to your VPC.
    Ensure the subnet is public: The subnet must be associated with this route table to have access to the internet. Resources in the subnet will also need public IP addresses or Elastic IP addresses.
    Verify the "local" route: Every route table includes a default "local" route that handles communication within your VPC. This is added automatically and should not be changed.

## HOW DOES ROUTE TABLE ASSOCIATION WORK?

Route table association connects a subnet to a route table, which dictates how traffic from that subnet is directed. This is done by creating an association between the subnet and the route table, causing the subnet's traffic to follow the rules within that specific table. A single route table can be associated with multiple subnets.

## WHAT ARE PORTS?

In networking, ports are virtual endpoints for communication that direct data to a specific process or service on a device. They are numbered (from 0 to 65535) and work with an IP address to ensure traffic reaches the correct application, like a specific apartment number within a building address.
