
# AWS EC2 Lab Guide Project Answers

---

## 1. What is EC2? Why is it considered Infrastructure as a Service (IaaS)?  
**Amazon EC2 (Elastic Compute Cloud)** is a service that provides resizable virtual servers (*instances*) in the cloud. It allows you to run applications, host websites, or store data without owning physical hardware.  

**Why IaaS?**  
EC2 is an **Infrastructure as a Service** model because AWS manages the underlying hardware (servers, storage, networking), while you control the software (OS, applications, security). You pay only for what you use, making it cost-effective and scalable.  

---

## 2. Launch Your First EC2 Instance  
**Step-by-Step Guide:**  
1. **Log in to AWS**: Go to the [AWS Management Console](https://aws.amazon.com/console/).  
2. **Open EC2 Dashboard**: Search for “EC2” and select **Instances**.  
3. **Launch Instance**: Click **Launch Instances**.  
4. **Choose an AMI**: Select a free-tier option like *Amazon Linux 2* or *Ubuntu*.  
5. **Select Instance Type**: Choose `t2.micro` (free tier eligible).  
6. **Configure Security Group**:  
   - Allow **SSH (Port 22)**: Restrict to your IP (e.g., `192.0.2.0/32`).  
   - Allow **HTTP (Port 80)** and **HTTPS (Port 443)**: Set source to `0.0.0.0/0` (anywhere).  
7. **Review & Launch**: Confirm settings and click **Launch**.  
8. **Download Key Pair**: Save the `.pem` file securely (e.g., `my-key.pem`).  

---

## 3. Connect to Your EC2 Instance via SSH  
**Steps:**  
1. **Find Public IP**: In the EC2 dashboard > **Instances** > Copy the instance’s **Public IPv4 address**.  
2. **Use SSH**:  

   - **For Amazon Linux**:  
     ```bash
     chmod 400 my-key.pem
     ssh -i "my-key.pem" ec2-user@<PUBLIC_IP>
     ```

   - **For Ubuntu**:  
     ```bash
     chmod 400 my-key.pem
     ssh -i "my-key.pem" ubuntu@<PUBLIC_IP>
     ```

---

## 4. Install a Web Server (Nginx)  
**For Amazon Linux:**  
```bash
sudo yum update -y          # Update packages
sudo yum install nginx -y   # Install Nginx
sudo systemctl start nginx  # Start the server
sudo systemctl enable nginx # Enable auto-start
````

**For Ubuntu:**

```bash
sudo apt update -y          # Update packages
sudo apt install nginx -y   # Install Nginx
sudo systemctl start nginx  # Start the server
sudo systemctl enable nginx # Enable auto-start
```

**Test**: Open your browser and enter the instance’s **Public IP**. You’ll see the Nginx welcome page.

---

## 5. Understanding Security Groups

**Purpose**:

* Security Groups act as virtual firewalls to control inbound/outbound traffic.
* They are **stateful**: If you allow inbound traffic, responses are automatically allowed out.

**Key Rules**:

* **SSH (Port 22)**: Restrict to your IP for security.
* **HTTP (Port 80)** and **HTTPS (Port 443)**: Allow from anywhere (`0.0.0.0/0`).

---

## 6. Elastic IP Addresses

**Steps to Assign**:

1. Go to **EC2 Dashboard** > **Elastic IPs** > **Allocate Elastic IP Address**.
2. Click **Allocate**, then **Associate** it with your instance.

**Why Use Elastic IPs?**

* Provides a static public IP (doesn’t change when you stop/start the instance).
* Avoids broken links if your instance’s IP changes.

---

## 7. Stop, Start, or Terminate an Instance

* **Stop**:

  * Shuts down the instance.
  * You’re not charged for compute time, but storage (EBS) costs apply.
* **Start**:

  * Restarts the instance.
  * May assign a new public IP (unless Elastic IP is used).
* **Terminate**:

  * **Permanently deletes** the instance and its storage.
  * **Warning**: This action cannot be undone!

---

## 8. Performance Optimization Tips

**For Junior DevOps Engineers**:

1. **Monitor with CloudWatch**: Track CPU, memory, and network usage.
2. **Resize Instances**: Upgrade to a larger type (e.g., `t3.medium`) if resources are strained.
3. **Use EBS-Optimized Instances**: Improves disk I/O performance.
4. **Enable Auto Scaling**: Automatically add/remove instances based on traffic.
5. **Check Logs**:

   ```bash
   sudo tail -f /var/log/nginx/access.log
   ```

```

