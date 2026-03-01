# Week 1 — IAM + CLI

## Objective
Operate AWS safely without using root.

## Tasks
- [ ] Enable MFA on root
- [ ] Create IAM admin user
- [ ] Create developer role
- [ ] Create custom IAM policy manually
- [ ] Configure AWS CLI profile
- [ ] Use STS to confirm role switching

## Deliverable
- No root usage
- CLI working with named profile
- Role switching verified

## Cost Check
Billing dashboard reviewed:
Current spend: £____

## Destroy Checklist
Not required this week.

## Notes / Evidence

**Region**
eu-west-2

**Admin User ARN**
arn:aws:iam::337128419551:user/keenanandrew-admin

**Developer Role ARN**
arn:aws:iam::337128419551:role/training-developer

**Assumed Role ARN (STS Test)**
arn:aws:sts::337128419551:assumed-role/training-developer/...

**Budget**
training-monthly-usd (30 USD)

**SNS Topic**
arn:aws:sns:eu-west-2:337128419551:training-billing-alerts

**Billing Notifications**
- 80% actual
- 100% actual

**Root MFA**
Enabled