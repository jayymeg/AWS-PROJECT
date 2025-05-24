# Scenario 2: Hosting a Static Website in Amazon S3

## Objective

Host a simple static website in an Amazon S3 bucket and make it fast for users in India and London using Amazon CloudFront (CDN).

---

# Step-by-Step Guide for a Beginner

## Step 1: Sign Into AWS and Open S3
	•	Log in to AWS.
	•	In the top search bar, type S3 and click the S3 service.

---

## Step 2: Create an S3 Bucket
	•	Click Create bucket.
	•	Enter a unique name (e.g., my-first-website-2025).
	•	Choose a region (e.g., US East (N. Virginia)).
	•	Uncheck Block all public access.
	•	Leave defaults and click Create bucket.

---

## Step 3: Enable Static Website Hosting
	•	Click your bucket name.
	•	Go to Properties > scroll to Static website hosting > click Edit.
	•	Enable it, then:
	•	Index document: index.html
	•	Error document: error.html (optional)
	•	Click Save changes.

---

## Step 4: Upload Website Files

Create two files on your computer:

### `index.html`

```html
<!DOCTYPE html>
<html>
  <head><title>Hello</title></head>
  <body>
    <h1>Hello, World!</h1>
    <p>Welcome to my website! It’s hosted on AWS S3.</p>
  </body>
</html>
```

### `error.html (Optional)`

```html
<!DOCTYPE html>
<html>
  <head><title>Error</title></head>
  <body>
    <h1>Oops!</h1>
    <p>Something went wrong. Try again later.</p>
  </body>
</html>
```


	•	In S3, go to the Objects tab.
	•	Click Upload, drag your index.html and error.html files, and confirm upload.

---

## Step 5: Make Website Public
	•	Go to Permissions tab > Bucket policy > click Edit.
	•	Paste the policy below, replacing the bucket name:


```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-first-website-2025/*"
    }
  ]
}
```

	•	Click Save changes.

---

## Step 6: Test Your Website
	•	Go to Properties > Static website hosting.
	•	Copy the website endpoint URL (e.g., http://my-first-website-2025.s3-website-us-east-1.amazonaws.com).
	•	Paste in browser—you should see your site!

---

## Step 7: Speed It Up with CloudFront
	•	In AWS Console, search for CloudFront > click Create Distribution.
	•	Origin domain: Use your S3 website endpoint (not the bucket name).
	•	Set Viewer protocol policy: Redirect HTTP to HTTPS.
	•	Click Create Distribution (wait 10–15 minutes).
	•	Test the CloudFront URL (e.g., https://d123456789.cloudfront.net).

---

## Step 8 (Optional): Add a Custom Domain
- •	Buy a domain (e.g., mywebsite.com).
- •	Set it up in Route 53.
- •	Point domain to your CloudFront distribution.
- •	(This step can be skipped if you don’t have a domain.)

---

Architecture Overview (Diagram Description)
- **S3 Bucket**: Stores your HTML and other files.
- **CloudFront**: Distributes content globally from edge locations.
- **Users**: Access the site faster from nearby CloudFront servers in India or London.

---

Final Tips
- **Website not showing?** Check:
- `index.html` is uploaded.
- Bucket policy is correct.
- CloudFront can take 10–15 minutes to set up.
- Updating files? Re-upload to S3 and invalidate cache in CloudFront.

---

### Files Summary
- `index.html`: Main website content.
- `error.html`: Optional error page.
- Public access via S3 policy.
- Faster delivery using CloudFront.

---
