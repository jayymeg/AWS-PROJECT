
# AWS Infrastructure Setup Guide

## Step 1: Create VPC

1. Go to AWS VPC Console: [https://console.aws.amazon.com/vpc](https://console.aws.amazon.com/vpc)
2. Click **Create VPC**
3. Configure:
   - **Name tag**: `ProjectVPC`
   - **IPv4 CIDR**: `10.0.0.0/16`
4. Click **Create**

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N1.png)

---

## Step 2: Create Public Subnets

1. In VPC Console, go to **Subnets** then click **Create subnet**
2. Configure:
   - **VPC**: `ProjectVPC`
   - **Subnet 1**:
     - **Name**: `PublicSubnet1`
     - **AZ**: `us-east-1a`
     - **CIDR**: `10.0.1.0/24`
   - **Subnet 2**:
     - **Name**: `PublicSubnet2`
     - **AZ**: `us-east-1b`
     - **CIDR**: `10.0.2.0/24`

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N2.png)


3. For each subnet:
   - Select subnet, click **Actions** > **Edit subnet settings**
   - Check **Enable auto-assign public IPv4 address**

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N3.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N4.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N5.png)

---

## Step 3: Create Internet Gateway

1. Go to **Internet Gateways**, click **Create internet gateway**
2. Name it `ProjectIGW`
3. Click **Create**, then **Attach to VPC**, and select `ProjectVPC`


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N6.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N7.png)

---

## Step 4: Configure Route Table

1. Go to **Route Tables**, select the main route table for `ProjectVPC`
2. Click **Edit routes**, then **Add route**:
   - **Destination**: `0.0.0.0/0`
   - **Target**: `ProjectIGW`
3. Go to **Subnet associations**, and associate both public subnets


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N8.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N9.png)

---

## Step 5: Create Security Groups

1. Go to **Security Groups**, click **Create security group**
2. For Load Balancer:
   - **Name**: `LoadBalancer-SG`
   - **Inbound rule**: Allow HTTP (port 80) from `0.0.0.0/0`

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N10.png)


3. For EC2 Instances:
   - **Name**: `WebServer-SG`
   - **Inbound rule**: Allow HTTP (port 80) from `LoadBalancer-SG`

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N11.png)

---

## Step 6: Create Application Load Balancer (ALB)

1. Go to EC2 Console > **Load Balancers**, click **Create**
2. Configure:
   - **Name**: `ProjectALB`
   - **VPC**: `ProjectVPC`
   - **Subnets**: Select both public subnets
   - **Security group**: `LoadBalancer-SG`
3. Listeners and routing:
   - Create new target group: `ProjectTargetGroup` (HTTP:80)
   - Health checks: Path `/`
4. Click **Create**

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N12.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N100.png)

---

## Step 7: Create Launch Template

1. Go to **Launch Templates**, click **Create launch template**
2. Configure:
   - **Name**: `ProjectTemplate`
   - **AMI**: Amazon Linux 2023
   - **Instance type**: `t2.micro`
   - **Security group**: `WebServer-SG`
3. Advanced settings – User data (paste the script below):

   ```bash
   #!/bin/bash
   # Install Node.js
   curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
   sudo yum install -y nodejs

   # Create app
   cat > app.js <<EOF
   const http = require('http');
   const server = http.createServer((req, res) => {
     res.writeHead(200, {'Content-Type': 'text/plain'});
     res.end('Hello from Auto Scaling Group!\n');
   });
   server.listen(80, '0.0.0.0');
   EOF

   # Start app
   nohup node app.js > output.log 2>&1 &
```


```
![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N13.png)

---

## Step 8: Create Auto Scaling Group (ASG)

1. Go to **Auto Scaling Groups**, click **Create**
2. Configure:

   * **Name**: `ProjectASG`
   * **Launch template**: `ProjectTemplate`
   * **VPC**: `ProjectVPC`
   * **Subnets**: Both public subnets
   * **Load balancing**: Attach to `ProjectALB`
3. Group size:

   * **Min**: 2
   * **Max**: 4
   * **Desired**: 2
4. Scaling policies:

   * Select **Target tracking scaling policy**
   * **Metric**: CPU Utilization
   * **Target value**: 80%
5. Click **Create**

![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N14.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N15.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N16.png)


![my image](https://github.com/jayymeg/AWS-PROJECT/blob/main/AWS-alb-autoscaling/N17.png)

---

## Step 9: Test Scaling

1. Get ALB DNS name:

   * Go to **Load Balancers**, copy DNS name of `ProjectALB`

2. Generate traffic using your terminal:

   ```bash
   # Install Apache Bench if needed
   # Ubuntu: sudo apt install apache2-utils
   # macOS: brew install apache2-utils

   # Replace <ALB-DNS-NAME> with actual DNS
   ab -n 100000 -c 100 http://<ALB-DNS-NAME>/
   ```

3. Monitor scaling:

   * In EC2 Console: watch the number of running instances
   * In Auto Scaling Group > **Activity tab**: check scaling events
   * In CloudWatch: monitor CPU usage

---

## Step 10: Clean Up

1. Delete Auto Scaling Group:

   * Select `ProjectASG` > **Actions** > **Delete**
   * Check **Force delete**
2. Delete Launch Template:

   * Select `ProjectTemplate` > **Actions** > **Delete template**
3. Delete ALB:

   * Select `ProjectALB` > **Actions** > **Delete**
4. Delete Target Group:

   * Select `ProjectTargetGroup` > **Actions** > **Delete**
5. Delete VPC:

   * Go to **VPC Console** > **Delete VPC** > Select `ProjectVPC`

---

## Key Verification Points

1. Website responds at ALB DNS name
2. Two instances launch initially across different AZs
3. New instances spawn when CPU reaches 80%
4. Extra instances terminate when load decreases
5. All resources are deleted after testing

---

## Troubleshooting Tips

* Can’t see instances? Check security group rules
* Scaling not working? Verify ASG metrics in CloudWatch
* Health check failures? Ensure Node.js app runs on port 80
* Cleanup issues? Delete resources in reverse order (ASG first)


