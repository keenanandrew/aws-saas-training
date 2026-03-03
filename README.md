# AWS SaaS Architecture — From Zero to Production

A 12-week technical course for engineers who want to understand AWS infrastructure, not just use it.

## What This Is

A self-paced course that builds a production-grade AWS architecture from scratch. Each week adds a layer — networking, compute, databases, containers, CI/CD, monitoring, serverless — until you have a real SaaS-ready infrastructure.

Every topic starts with **why it matters** (real incidents, cost implications, architectural trade-offs) before telling you what to do.

## Running the Course Interface

The course has a browser-based interface for viewing the curriculum and tracking progress. To run it:

```bash
# Option A: Python (built-in)
python -m http.server 8000 --directory app

# Option B: Node.js
npx serve ./app

# Option C: Any static file server pointed at the ./app directory
```

Then open http://localhost:8000 in your browser.

Progress is saved in your browser's localStorage.

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

## Rules

- Monthly cost cap: £25
- No resource survives the weekend
- Destroy before moving to next module
- Review billing every Friday
- Tag everything: `Environment=training`, `Owner=keena`

## Repo Structure

```
├── app/                    # Browser-based course interface
│   ├── index.html          # Single-page app (no dependencies)
│   └── curriculum.json     # Full course content (12 weeks)
├── roadmap/                # Original markdown notes per week
├── terraform/              # Infrastructure as code
│   └── vpc/                # Week 2 VPC resources
├── artifacts/              # IAM policies, budget configs
├── destroy-checklist.md    # Weekly teardown checklist
└── README.md
```

## Region

eu-west-2 (London)
