# Week 2 — VPC + Networking (Terraform, No NAT)

## Objective

Create a cost-safe VPC using Terraform that will serve as the networking foundation for the SaaS application. Understand why every architectural decision matters.

Cost target: ~£0 idle cost.

---

## Why This Matters

In 2019, Capital One disclosed a breach affecting 106 million customers. The attacker exploited a misconfigured WAF to access an EC2 instance's metadata service, which returned IAM role credentials with broad S3 access.

The instance was in a VPC, but the network configuration allowed the attack path. The post-incident analysis identified the network architecture as a contributing factor: the EC2 instance had more network access than it needed, and security groups were overly permissive.

A VPC is not just a container for your resources — it's your first architectural decision about what can talk to what. Public subnets expose resources to the internet. Private subnets don't. This week, you build the network. In future weeks, every resource you create goes into either the public or private subnet, and you'll need to justify why.

---

## Key Concepts

### VPC = Your Private Data Centre in the Cloud

A VPC is a logically isolated section of AWS where you launch resources. Without one, your resources sit in AWS's default network. A VPC gives you:

- **Isolation**: Other AWS customers can't reach your resources.
- **Control**: You define the IP range, subnets, route tables, and access rules.
- **Segmentation**: Separate public-facing components (load balancers) from private ones (databases).

### CIDR Blocks and Subnets

`10.20.0.0/16` gives you 65,536 addresses. Subnets divide this:
- `10.20.1.0/24` = 256 addresses (public range, low numbers)
- `10.20.101.0/24` = 256 addresses (private range, high numbers)

Convention: low numbers (1-99) for public, high numbers (101-199) for private. From an IP address, you can immediately tell if a resource is public-facing or internal.

AWS reserves 5 addresses per subnet, so a /24 gives 251 usable addresses.

### Public vs Private Subnets

A subnet is "public" if it has a route to an Internet Gateway. A subnet is "private" if it doesn't. There's no checkbox — it's determined entirely by the route table.

- **Public**: Load balancers, bastion hosts, NAT gateways.
- **Private**: Application servers, databases, caches, internal services.

**The NAT question**: Private resources that need outbound internet access need a NAT Gateway (~$32/month). We skip it here to save cost. The trade-off: private resources can't reach the internet.

### Why Terraform (Not ClickOps, Not CloudFormation)

You could create a VPC through the Console in 10 minutes. But then you can't reproduce it, review changes, destroy it cleanly, or version-control it.

Terraform over CloudFormation: Terraform works across providers (AWS, GCP, Azure), has a larger ecosystem, and HCL is more readable than CloudFormation YAML.

---

## Architecture

```
VPC: 10.20.0.0/16
├── Public Subnet: 10.20.1.0/24 (eu-west-2a)
│   ├── Route: 0.0.0.0/0 → Internet Gateway
│   └── Auto-assign public IPs: yes
├── Private Subnet: 10.20.101.0/24 (eu-west-2a)
│   ├── Route: local only
│   └── No internet access
└── Security Group: training-sg-app
    ├── Inbound: none (will be added as services are deployed)
    └── Outbound: all traffic allowed
```

---

## Tasks

- [x] Install Terraform CLI
  - **Why**: Industry standard for AWS IaC. You need fluency.
- [x] Create terraform/vpc directory
- [x] Configure AWS provider (eu-west-2, training-admin profile)
- [x] Create VPC resource
  - **Why**: The VPC is the boundary. Everything else lives inside it.
- [x] Create Internet Gateway
- [x] Create Public subnet
- [x] Create Private subnet
  - **Why**: The public/private split is the most fundamental network architecture pattern in AWS.
- [x] Create route tables and associate subnets
  - **Why**: Route tables determine what's public and what's private. This is the decision.
- [x] Create base application security group
  - **Why**: Starting with zero inbound rules = least privilege applied to networking.
- [x] Add Terraform outputs
- [x] Run terraform init + apply
- [x] Confirm no NAT gateways exist
  - **Why**: NAT gateways cost ~$32/month idle. VPCs, subnets, and route tables are free.
- [x] Confirm no EC2 instances exist
- [x] Destroy and recreate
  - **Why**: If you can't destroy and rebuild in minutes, you don't have IaC — you have a to-do list.

---

## Code Challenge: Subnet Design

Design a VPC for a SaaS app needing: a public-facing API, a private app tier, a private database tier, and HA across two AZs.

```
VPC CIDR: 10.0.0.0/16

AZ: eu-west-2a
  Public subnet A:  10.0.1.0/24   → ALB, NAT Gateway
  App subnet A:     10.0.11.0/24  → ECS tasks / EC2
  Data subnet A:    10.0.21.0/24  → RDS primary, ElastiCache

AZ: eu-west-2b
  Public subnet B:  10.0.2.0/24   → ALB, NAT Gateway
  App subnet B:     10.0.12.0/24  → ECS tasks / EC2
  Data subnet B:    10.0.22.0/24  → RDS standby
```

**Why two AZs?** AWS AZs are physically separate data centres. An AZ failure (rare but real — us-east-1 had one in Dec 2021) takes down everything in that AZ. Two AZs means your app survives a single AZ failure.

---

## Terraform Outputs

VPC ID: vpc-02192e4c462ffff9f

Public Subnet ID: subnet-066792c13d1e0936b

Private Subnet ID: subnet-088c8e2653c30ed91

Application Security Group: sg-0fca8e318a8fdf028

---

## Verification Commands

Confirmed no NAT gateways:

```powershell
aws ec2 describe-nat-gateways --region eu-west-2 --profile training-admin --query "NatGateways[].NatGatewayId"
```

## Cost Check
Billing dashboard reviewed: ✓
Current spend: £0.00
