# Step-by-Step Execution of Scenario 1: Building a Fast Website for India and London Users

## Objective
We’ll create a simple static website, host it on AWS S3, and use CloudFront to make it load quickly for users in India and London by caching the content closer to them. We’ll also test the website to ensure it works.

---

## Step 1: Create a Simple Static Website File

1. **Open a Text Editor**  
   Use a text editor like Notepad (Windows), TextEdit (Mac), or any code editor (e.g., VS Code).

2. **Create a File Called `index.html`**  
   Copy and paste the following code into the editor:

   ```html
   <html>
     <head><title>My Website</title></head>
     <body>
       <h1>Hello from My Website!</h1>
       <p>This website is for users in India and London.</p>
     </body>
   </html>

3. **Save the File**
Save it as index.html on your computer (e.g., on your Desktop or in a folder).

---

## Step 2: Sign Up or Log In to AWS
	
 1.	**Go to AWS**
Open your browser and go to https://aws.amazon.com
	
 2.	**Log In or Sign Up**
	- **If you have an AWS account: Click Sign In to the Console and log in.**
	•	If you don’t:
	•	Click Create an AWS Account
	•	Provide your email, password, and billing information (AWS offers a free tier).
	•	Once logged in, you’ll see the AWS Management Console.

---

Step 3: Create an S3 Bucket to Store Your Website
	1.	Find S3
In the AWS Console, search for S3 and click it.
	2.	Create a Bucket
	•	Click Create bucket
	•	Bucket Name: e.g., my-india-london-website-2025
	•	Region: Asia Pacific (Mumbai) ap-south-1
	•	Object Ownership: Default (ACLs disabled)
	•	Block Public Access: Uncheck Block all public access
	•	Click Create bucket
	3.	Upload Your Website File
	•	Click on your new bucket
	•	Click Upload
	•	Drag and drop index.html
	•	Click Upload
	4.	Enable Static Website Hosting
	•	Go to the Properties tab
	•	Scroll to Static website hosting → Click Edit
	•	Enable it and set Index document to index.html
	•	Save changes
	•	Copy the website link to test (e.g., http://my-india-london-website-2025.s3-website.ap-south-1.amazonaws.com)

⸻

Step 4: Secure the S3 Bucket
	1.	Go to Permissions
Inside your bucket, go to the Permissions tab.
	2.	Block Public Access
	•	Scroll to Block public access
	•	Click Edit
	•	Check Block all public access
	•	Click Save changes
	•	Confirm when prompted
	3.	Set Up a Bucket Policy
We’ll come back to this after creating CloudFront.

⸻

Step 5: Set Up CloudFront to Deliver the Website Quickly
	1.	Find CloudFront
In the AWS Console search bar, type CloudFront, then click the service.
	2.	Create a Distribution
	•	Click Create distribution
	•	Origin Domain: Select your S3 bucket endpoint
	•	Origin Access: Choose Legacy access identities
	•	Create a new OAI: Name it e.g., MyWebsiteOAI
	•	Grant Read Permissions on Bucket: Select Yes, update the bucket policy
	•	Viewer Protocol Policy: Redirect HTTP to HTTPS
	•	Default Root Object: index.html
	•	Price Class: Use only North America, Europe, Asia, Middle East, and Africa
	•	Click Create distribution
	3.	Wait for Deployment
	•	Takes 10–15 minutes
	•	Copy the Domain Name once deployed (e.g., https://d123456789.cloudfront.net)

⸻

Step 6: Verify the S3 Bucket Policy
	1.	Return to S3
Go to your S3 bucket.
	2.	Check the Bucket Policy
Under Permissions > Bucket Policy, you should see something like:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity XYZ"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-india-london-website-2025/*"
    }
  ]
}



⸻

Step 7: Test Your Website
	1.	Use the CloudFront Link
Open the CloudFront domain (e.g., https://d123456789.cloudfront.net) in your browser.
	2.	Test from India and London
	•	Ask a friend in India/London or use a VPN
	•	Or use https://www.webpagetest.org
	•	Speed should be under 1–2 seconds

⸻

Step 8: Optional – Add a Custom Domain
	1.	Go to Route 53
In AWS Console, search and open Route 53.
	2.	Create a Hosted Zone
	•	Click Create hosted zone
	•	Enter your domain (e.g., mywebsite.com)
	•	Click Create hosted zone
	3.	Add a Record
	•	Click Create record
	•	Record name: leave blank or enter www
	•	Record type: A – IPv4 address
	•	Turn on Alias
	•	Route traffic to: Alias to CloudFront distribution
	•	Choose your CloudFront distribution
	•	Click Create records
	4.	Update Your Domain’s DNS
	•	Copy the Route 53 Name Servers
	•	Go to your registrar (e.g., GoDaddy) and update the nameservers
	5.	Add SSL Certificate
	•	Go to AWS Certificate Manager (ACM)
	•	Request a public certificate
	•	Add your domain (e.g., mywebsite.com, *.mywebsite.com)
	•	Use DNS validation
	•	Once issued, go to CloudFront → Edit Distribution → attach the certificate
	6.	Test Your Domain
	•	Visit https://mywebsite.com and verify it loads

⸻

Step 9: Check Everything Works
	•	Speed: CloudFront delivers from nearby (e.g., Mumbai, London)
	•	Security: S3 is private, CloudFront uses HTTPS
	•	Cost: Free tier eligible, but monitor AWS Billing Dashboard

⸻

✅ What You’ve Done
	•	Created a static website (index.html)
	•	Hosted it on S3 and enabled website hosting
	•	Used CloudFront to improve performance for India and London
	•	Tested and optionally set up a custom domain

Your website is now live and optimized for global delivery!

