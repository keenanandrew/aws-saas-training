# Week 1 — IAM + CLI

## Objective
Operate AWS safely without using root. Establish a secure account structure with role-based access that mirrors how real teams work.

---

## Why This Matters

In January 2020, an engineer at a fintech startup committed AWS root credentials to a public GitHub repo. Within 4 hours, attackers had spun up 200 GPU instances for crypto mining. The bill was $46,000.

This is not unusual. Leaked credentials are the #1 cause of unexpected AWS bills. Root credentials are especially dangerous because they have unrestricted access to every service and cannot be limited by IAM policies.

The solution: lock root behind MFA, create IAM users with scoped permissions, and use roles for day-to-day work. You learn IAM first because every other week in this course depends on it.

---

## Key Concepts

### The IAM Mental Model

IAM answers three questions:

1. **Who are you?** (Authentication) — Users, roles, and federated identities.
2. **What can you do?** (Authorization) — Policies attached to users/roles that allow or deny actions.
3. **On what?** (Resource scope) — ARNs that specify exactly which S3 bucket, EC2 instance, or DynamoDB table a policy applies to.

Every AWS API call is evaluated against these three questions. If any answer is "no" or "not specified", the call is denied (default-deny).

### Users vs Roles

A **user** has long-lived credentials (access key + secret key). These sit in `~/.aws/credentials` and don't expire. If they leak, an attacker has access until you revoke them.

A **role** has no permanent credentials. Instead, you "assume" a role and receive temporary credentials (via STS) that expire after 1-12 hours. If they leak, the damage window is limited.

Production best practice: humans use roles via SSO/federation. Services use roles attached to their compute (EC2 instance profile, ECS task role, Lambda execution role). Access keys for IAM users are a last resort.

### Policy Anatomy

An IAM policy is a JSON document:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["s3:GetObject", "s3:PutObject"],
    "Resource": "arn:aws:s3:::my-bucket/*",
    "Condition": {
      "StringEquals": { "s3:prefix": "uploads/" }
    }
  }]
}
```

- **Effect**: Allow or Deny. Deny always wins.
- **Action**: The API calls this covers. `s3:*` = all S3 actions. Be specific.
- **Resource**: The ARN(s) this applies to. `*` = everything — avoid this.
- **Condition**: Optional constraints (IP ranges, MFA, tag values).

The Version field is always `2012-10-17` — it's the policy language version, not a date you set.

---

## Tasks

- [x] Enable MFA on root
  - **Why**: Root has unrestricted access. MFA ensures a leaked password alone isn't enough.
- [x] Create IAM admin user
  - **Why**: Replaces root for day-to-day admin work. Revocable and auditable.
- [x] Create developer role
  - **Why**: Simulates real team environments. Developers assume a scoped role.
- [x] Create custom IAM policy manually
  - **Why**: Real security requires custom policies. Writing them teaches tag-based access control.
- [x] Configure AWS CLI profile
  - **Why**: Named profiles prevent accidentally running commands with wrong credentials.
- [x] Use STS to confirm role switching
  - **Why**: Proves the role trust chain works before you depend on it.
- [x] Set up billing alerts
  - **Why**: A NAT gateway you forgot costs ~$32/month. Alerts are your safety net.

---

## Code Challenge: Policy Debugging

The following policy is supposed to allow a developer to manage EC2 instances only in eu-west-2. It has three bugs:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": "ec2:TerminateInstances",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": "eu-west-2"
        }
      }
    }
  ]
}
```

**Bugs:**
1. The first statement has no region constraint — `ec2:*` is allowed globally.
2. The Deny only covers TerminateInstances. RunInstances, CreateVolume, etc. are still allowed in other regions.
3. `ec2:*` includes IAM-adjacent actions like `ec2:CreateKeyPair`. Too broad for a developer role.

---

## Deliverable
- No root usage
- CLI working with named profile
- Role switching verified

## Evidence

**Region**: eu-west-2

**Admin User ARN**: arn:aws:iam::337128419551:user/keenanandrew-admin

**Developer Role ARN**: arn:aws:iam::337128419551:role/training-developer

**Assumed Role ARN (STS Test)**: arn:aws:sts::337128419551:assumed-role/training-developer/...

**Budget**: training-monthly-usd (30 USD)

**SNS Topic**: arn:aws:sns:eu-west-2:337128419551:training-billing-alerts

**Billing Notifications**: 80% actual, 100% actual

**Root MFA**: Enabled

## Cost Check
Billing dashboard reviewed: ✓
Current spend: £0.00

## Destroy Checklist
Not required this week.
