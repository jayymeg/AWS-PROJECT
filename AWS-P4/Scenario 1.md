# Step-by-Step Execution of Scenario 1: Building a Fast Website for India and London Users
## Objective
Create a simple static website, host it on AWS S3, and use CloudFront to make it load quickly for users in India and London by caching the content closer to them. Test the website to ensure it works.
## Step 1: Create a Simple Static Website File
Open a text editor
Create file `index.html`:
```html
<html>
  <head><title>My Website</title></head>
  <body>
    <h1>Hello from My Website!</h1>
    <p>This website is for users in India and London.</p>
  </body>
</html>
```
Save the file
## Step 2: Sign Up or Log In to AWS
Go to [AWS](https://aws.amazon.com)
Log in or create new account
Access AWS Management Console
## Step 3: Create S3 Bucket
Search for S3 in console
Create bucket:
Bucket name: `my-india-london-website-2025`
Region: `Asia Pacific (Mumbai) ap-south-1`
Object Ownership: `ACLs disabled`
Uncheck "Block all public access"
Upload `index.html`
Enable static website hosting:
Properties → Static website hosting → Edit
Enable hosting
Index document: `index.html`
Note URL: `http://my-india-london-website-2025.s3-website.ap-south-1.amazonaws.com`
## Step 4: Secure S3 Bucket
Permissions → Block Public Access:
Edit → Check "Block all public access" → Save
Bucket policy will be set later
## Step 5: Set Up CloudFront
Search for CloudFront in console
Create distribution:
Origin Domain: Select S3 bucket endpoint
Origin Access: Legacy access identities
Create new OAI: `MyWebsiteOAI`
Grant Read Permissions: Yes
Viewer Protocol Policy: Redirect HTTP to HTTPS
Default Root Object: `index.html`
Price Class: North America/Europe/Asia/Middle East
Wait 10-15 minutes for deployment
Note Domain Name: `https://d123456789.cloudfront.net`
## Step 6: Verify S3 Bucket Policy Check bucket policy matches:
```json
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
```
## Step 7: Test Your Website
Access CloudFront URL: `https://d123456789.cloudfront.net`
Test from India/London using VPN or [WebPageTest](https://www.webpagetest.org)
Target load time: 1-2 seconds
## Step 8: Optional – Custom Domain
Route 53 → Create hosted zone for your domain
Create A-record pointing to CloudFront distribution
Update DNS at domain registrar
Request SSL certificate in AWS Certificate Manager
Attach certificate to CloudFront distribution
## Step 9: Final Verification
Confirm global accessibility
Validate HTTPS enforcement
Check S3 bucket security
Monitor AWS Billing Dashboard
## Completion
Created static website
Hosted on S3 with CloudFront acceleration
Optimized for India/London users
Tested performance and security
