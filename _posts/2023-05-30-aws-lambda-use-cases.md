---
layout: post
title: "AWS Lambda Use Cases: When You Should Use It?"
date: 2023-05-30 09:00:00 -0500
author: Jon Goodall
categories: [DevOps, Cloud, AWS]
tags: [aws, lambda, serverless, faas, cloud-computing, architecture]
excerpt: "Lambda and Serverless is rather 'in' right now. But how much of the marketing spiel should you listen to? Let me help you figure out when to actually use AWS Lambda."
canonical_url: https://www.logicata.com/blog/aws-lambda-use-cases/
image: /img/AWS_Lambda_logo-1536x1536.png
---

Lambda, and Serverless in general, is rather "in" right now in the world of cloud computing. If you listened to all the marketing coming out from the big names about it (and yes, I'm guilty of this too); you'd expect that you can run your whole service on it. For next-to-nothing, with no downtime, and your deployments would be as smooth as silk.

So, how much of the marketing spiel should you listen to – how do you know when to use Lambda? Well, I'm going to try and come up with a reasonable list of use cases for AWS Lambda, so that's a good place to start.

![AWS Lambda Logo](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/sr05x6kgmsnqxmcrnl48.png)

## What Is Lambda?

Before we get into "what's it for", it's worth defining "what it is", so let's do that.

AWS Lambda is AWS's take on "Function as a Service" (FaaS). It allows developers to run code without provisioning or managing servers. With AWS Lambda, developers can upload their code, and the service will take care of the rest – including scaling, patching, and availability.

The idea behind AWS Lambda is to make it easier for developers to build scalable, event-driven applications that run on the cloud. The service is highly-available and fault-tolerant. Which means that it can handle large amounts of traffic without crashing or experiencing downtime. One of the key benefits of using AWS Lambda is that it is fully managed. This means that developers don't have to worry about managing hardware or operating systems. They can focus on building applications, while AWS Lambda takes care of the underlying infrastructure.

AWS Lambda supports a variety of programming languages, including Java, Python, Node.js, C#, and Go. This makes it easy for developers to write code in the language they are most comfortable with, without having to learn a new language or platform.

Another advantage of AWS Lambda is that it provides automatic scaling. This means that the service adjusts the number of functions serving requests. If there is a sudden increase in traffic, AWS Lambda will scale out the number of functions to handle the load. Conversely, if there is a decrease in traffic, the service will scale in the functions to reduce costs.

AWS Lambda is also cost-effective. Developers only pay for the compute time that their code actually uses. This means that if an application isn't in use, there are no costs associated with running it. Additionally, since AWS Lambda scales based on demand, developers can avoid over-provisioning and paying for unused resources.

That's all fine and good, but what exactly do you use it for?

## AWS Lambda Use Cases

### Use Cases for AWS Lambda #1: Glue

![Arts and Crafts with Glue](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/431fre5ap0rnw6torcmm.jpeg)

Now I'm not talking about AWS Glue but rather using Lambda to "glue" (or "stitch" if you prefer) other AWS services together.

**Why would you use Lambda for this?**

A few reasons.

Lambda can bridge two services that don't talk to each other. For instance, when an API Gateway call is made to retrieve a file from an S3 bucket, Lambda can facilitate the interaction between the two.

In some cases, the services do talk to each other, but filtering the results can be challenging. For instance, API Gateway and DynamoDB. Yes, API Gateway can talk to tables, but it's not easy to work out how or to combine queries from several tables into a single result.

Event-driven architectures. Say you wanted to process an image after uploading to S3, you could send a notification to a queue and have an EC2 instance handle the message processing. Or do this with Lambda, because it's only charging you when it's running. In the same vein, you can use Lambda can act as a replacement for cron-triggered scripts, again saving money.

"Gluing" things together is a lot of the work I've seen/done used with lambdas as they're quick to build & deploy and cheap to run. In most of the deployments I've seen, the CloudWatch bill for monitoring the lambdas was higher than the bill for the lambdas themselves.

### Use Cases for AWS Lambda #2: APIs

So, you can't use Lambda's as APIs by themselves but put them behind either API Gateway or an ALB, and you can.

Most APIs are "call-and-response" in that a client calls an endpoint for "something,". This could be data, to kick off background processing or anything else.

**Why would you use Lambda for this?**

Once again, it's about cost and resource utilization.

Lambdas can be permanently provisioned and react in very short spaces of time. So they complete the processing and respond to the user for a much lower cost than a server or container can.

### Use Cases for AWS Lambda #3: Websites

This one is a bit out there but go with me on it.

Most "modern" websites consist of dynamically constructed pages. The pages are rendered and served in real-time, per request to the user.

Most webpages don't do complex processing on the same thread that is serving the page to the user, as this improves the user experience.

**Why would you use Lambda for this?**

For exactly the same reasons as using it for the backend or an API.

You don't have to have a server, which might only get occasional use, and instead, only pay when people are using the service. You also have a lot less to worry about when it comes to scaling to meet demand, as the lambda service does this for you.

### Use Cases for AWS Lambda #4: Data Processing & ETL

![Data Processing](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/6mne68geccos5cfslzue.jpeg)

This is similar to the "glue" use case but different enough that I thought it deserved its own section.

ETL (Extract, Transform, Load) is the process of taking data from one data source, changing its format or adding content, and loading it into another data storage platform.

**Why would you use Lambda for this?**

A couple of reasons, depending on your requirements:

Lambda can be triggered directly from other AWS services. Meaning when data is added to one of the sources, the processing starts quickly in response.

For instance, you could subscribe your Lambda to the event stream from a DynamoDB table, which allows the Lambda to start working within 1 second of the data being added.

Lambda also scales in response to demand, so if you have a period of a large volume of data being added to sources, it will be able to keep up and keep feeding your data warehouse in near-real-time.

Lambda can be called by AWS Step Functions, which allows for complex processing from multiple data sources, whilst being able to break the logic down into very small component parts. This can make the development easier to break up between team members and improve the testability of the system.

### Use Cases for AWS Lambda #5: Containerized Workloads

![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/igcv49y41c5qu1k2q8qe.jpeg)

Again, out of left field on this but bear with me.

Since Docker was added as a Lambda runtime environment, you can use Lambda to run anything you'd run in Docker.

The caveat is that it must complete within 15 minutes and use less than 10GB of RAM. I know I touched on this at the start of the article, but it's definitely worth going into more detail on this.

**Why would you use Lambda for this?**

We're back on the same benefits again – cost and complexity. I've done the cost thing a few times now, so I'll skip that and go to the complexity piece instead.

Running Docker-based workloads in a highly-available manner is difficult and requires some level of orchestration (e.g. Docker Swarm, ECS or Kubernetes.

Managing the orchestration tools is a job in and of itself. Yes, AWS can take some of that away in their managed services; but your engineers still need to understand how to manage the tools.

With Lambda, that goes away as it scales to meet demand. Additionally, deployment is as trivial as uploading a Docker image (though you really should be using a CI/CD setup).

### Use Cases for AWS Lambda #6: ChatBots & Voice Assistants

![ChatBot](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/97shciomgqa6toigc8uf.jpeg)

ChatBots are on almost every website these days, so I don't think I need to explain them. If you have a customer service setup of some sort, you either already have a ChatBot on your website, or are thinking/have thought about it.

**Why would you use Lambda for this?**

Because it can interface using the API/SDK with things like Lex and Polly, you can use Lambda to get data from APIs or other areas of your infrastructure and send them back to the user via the bot.

I can't promise that your users will actually like the bot, but that's more to do with the information it's sending back than the technology.

## Closing Thoughts

The hype is more or less correct, and you can use Lambda to run almost anything for a low cost. The biggest drawback is that you have to reframe your thought process. It's a bit of a mental jump to think about serving web pages out of the same service that you're using to shuffle data around in your backend, but it can be done.
