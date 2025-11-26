## some pre-course notes on VPCs, subnets, etc.

## WHAT IS A VPC?

VPC stands for Virtual Private Cloud. In contrast to the public cloud, i.e. AWS/Google/Azure standard resources that we've been using so far, a VPC is something
you can set up to reserve and cordon off cloud resources such as ec2, databases etc. This is done for multiple reasons.

- It's more secure: only systems that have the correct access information (security groups, ports, gateways, IPs etc) can interact with resources on the VPC,
  a bit like a "firewall" for your resources.

- We have more control: we can control traffic to the resources on the VPC more easily with IP ranges, subnets etc.

- We can still scale and add resources as we can with a public cloud.

## WHAT IS A SUBNET?

A subnet is a 'sub-network', i.e. a part of a network that can be partitioned off for a specific use or group. Subnets are created by using a 'subnet mask' to divide the host portion of an IP address into a smaller group of addresses. Why?

- Devices within the same subnet can communicate directly, while communication between different subnets must pass through a router. It's faster. By keeping traffic local, subnets prevent unnecessary traffic from flooding the entire network, leading to faster speeds.

- Subnets allow network administrators to isolate and control access between different groups of devices, for example, by separating a guest Wi-Fi network from the company's internal computers.

"A subnet, as the name tells you, is a sub-network -- a logical subdivision of a local network.

They're typically used in large enterprise environments to keep different types of traffic separate -- subnetting makes it easier to keep your production and development computers separate, for example."
