# AWS SaaS Architecture — From Zero to Production

A 12-week self-paced course covering AWS infrastructure from IAM to multi-tenant SaaS architecture.

## About This Project

This course was written and is maintained by AI (Claude and ChatGPT), as an experiment in self-guided technical learning supported by LLMs. A human learner defines the objectives and critiques the output; the LLMs generate the curriculum, explanatory material, code challenges, and the browser-based course interface.

The content is technical and opinionated. It skips the fluff and focuses on real architectural decisions, real-world failure modes, and the "why" behind every task.

## Running the Course

The course runs as a local web app — no server, no accounts, no dependencies.

```bash
python -m http.server 8000 --directory app
```

Open http://localhost:8000. Progress is saved in your browser's localStorage.

## Curriculum

| Week | Topic | What You Build |
|------|-------|---------------|
| 1 | IAM + CLI | Secure account, roles, CLI profiles |
| 2 | VPC + Networking | Public/private subnets, route tables, security groups |
| 3 | Compute: EC2 | Web server in your VPC |
| 4 | Load Balancing + Auto Scaling | ALB + ASG for high availability |
| 5 | DNS + TLS | Route 53, ACM certificate, HTTPS |
| 6 | Databases: RDS | PostgreSQL in a private subnet |
| 7 | Storage + CDN | S3 + CloudFront |
| 8 | Containers: ECS Fargate | Dockerised app on managed containers |
| 9 | CI/CD | GitHub Actions → ECR → ECS pipeline |
| 10 | Monitoring + Alerting | CloudWatch dashboards, alarms, log aggregation |
| 11 | Serverless | Lambda + API Gateway |
| 12 | Multi-Tenancy | Tenant isolation, RLS, cost attribution, final architecture |

## Repo Structure

```
app/
  index.html              Single-page course interface (no dependencies)
  curriculum.json          Full 12-week course content
roadmap/
  week-01-iam.md           Completed week notes with evidence
  week-02-vpc.md           Completed week notes with evidence
terraform/
  vpc/                     Week 2 Terraform (VPC, subnets, security groups)
artifacts/                 IAM policies and budget configs from week 1
destroy-checklist.md       Weekly resource teardown checklist
```

## Cost Rules

- Budget: £25/month
- Destroy all resources before moving to the next week
- Review billing every Friday
- Tag everything: `Environment=training`, `Owner=keena`
- Region: eu-west-2 (London)
