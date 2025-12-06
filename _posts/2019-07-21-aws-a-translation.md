---
layout: post
title: "AWS, a translation"
date: 2019-07-21 09:00:00 -0500
author: Jon Goodall
categories: [DevOps, Cloud, AWS]
tags: [aws, cloud, ec2, s3, lambda, kubernetes, devops, certification]
excerpt: "I've not long passed my AWS Certified Solutions Architect — Associate exam, and whilst studying I noticed that a lot of the service names are 'odd'. Or acronyms. Or Greek. Let me decode them for you."
image: /img/aws.png
---

I've not long passed my "AWS Certified Solutions Architect — Associate" exam (that's a mouthful), and whilst I was studying for it I noticed that, a lot of the service names are "odd". Or acronyms. Or Greek. I've covered this sort of topic before, (see: [here](/2024/12/06/whats-in-a-name-devops-edition.html)), so I thought I'd do it again, with a similar level of brevity. And snark.

There are a lot of services available, so for the sake of my own sanity I'm not covering them all. Also, Amazon has a habit of releasing new services quicker than the drink runs out at an open bar, making it highly likely another few will turn up whilst I'm writing this.

Also worth noting, just by reading this you WONT pass the "AWS-SA-Assoc" exam as there aren't any questions about what the names mean. It's more about how you use the services.

## AWS

Yep. Starting here. AWS is an acronym (and there's a lot of them coming up) for Amazon Web Services. But you probably already knew that. A word of warning, a lot of the names are about this creative. le sigh.

Fun(?) fact, AWS made up 58% of Amazons' profit in 2018 (source: [Investopedia](https://www.investopedia.com/how-amazon-makes-money-4587523)). So you can feel better about all the money you've spent on Amazon. At least that's what I'm clinging to.

## The Starting Tools

OK. Seems like a good place to start. Well, re-start. These are the tools that AWS is most known for. It's probably where you're going to get started with it too.

### EC2

Elastic Compute Cluster. Yep. Gonna need to define that one a bit.

In this sense "Elastic" is not that far from an elastic band. The capacity of your resources can stretch and shrink to meet demand, within limits. Compute is running apps, although in this case it refers to virtual servers. Cluster means there's more than one.

Still awake?

### S3

Simple Storage Service. It's got 3 S's, so S3. This is an object store, rather than a file store (though Amazon does have one of those too). It's interchangeable with file storage to an extent. But instead of using native OS commands you interact with it using the AWS CLI tool. Yes I know, more acronyms.

### VPC

Virtual Private Cloud.

To understand this you need to understand the difference between public and private cloud. The short version is "with private cloud you own it all, and are the only person (or company) on the hardware. With public cloud, none of that is true (in most cases, but I'm not going to go into that here).

A VPC allows you to treat AWS as if it's all yours. You're not going to see anyone else's resources when you log in, and they wont ever see any of yours either.

For the most part in AWS you have no idea that anyone else is using the service, except for a few unique naming rules.

### Route53

DNS (I'm sorry, I'm at it again), Amazon style.

Domain Name System is a translator, between human readable web addresses and an IP address. For example www.google.co.uk has an ip of 216.58.204.3 which your PC uses on the internet (yes that is actually google.co.uk's IP). Route53 is Amazons implementation.

It's named after 2 things. Route66 was the first highway in the U.S.A., and DNS servers work on port 53. Kinda creative I guess?

### CloudWatch

You can "watch" your "cloud" resources. CloudWatch. This covers metrics and logs, but there are different charges depending on what you're looking at.

You can do some cool stuff with logs, like exporting them to other tools for analytics and graphing.

### CloudTrail

Auditing. Well, an audit "trail" on your "cloud". Same sort of naming convention here.

### EBS

Elastic Block Store.

This is virtual disk, but it's a type of disk suited to reading and writing in "blocks". Databases tend to use this sort of storage type, as it has a much faster read & write speed.

### RDS

Relational Database Service.

Amazon will set up and manage a "Highly Available" (HA) cluster of a database engine of your choice. Not all DBMS's are available (sorry Sybase users), but the common ones are there.

You still get CLi and SSH access too, which is nice if you need/want/like to fine-tune anything.

You can pretty much use this as a drop-in replacement for an on-premises DB cluster, but you can't quite do without a DBA. You will also need some EBS (see above).

### IAM

Identity Access Management (what?)

This is AWS's "permissions" setup. It's a way to control who gets access to what. Broken down into users, groups, roles & policies. Users go into groups. Roles can be applied to groups or users. Policies are attached to roles.

The upshot of this, is servers/other resources can hold an "IAM Role". This allows them access to do/see/get/change something from another service, without having to create service accounts. If you've ever used them in the past, you'll understand why this is "A Good Thing TM".

### EFS

Elastic File Store.

Basically a network drive. Cool pricing model — you just use it, and pay for what you use. Unlike disk-based storage pricing, where you have provision and pay for a whole disk. One less headache.

Phew. Time for a break. Actually please don't leave. It gets better I promise.

Have a coffee. On me.

## The Intermediate Tools

These are tools that you will use a lot, once you're over the initial "what's this cloud thing?" hurdle. If you're lucky, you'll skip the hurdle and crack right on with these too.

### ECS & ECR

Elastic Container Service & Elastic Container Registry.

Right, containers. They'd come up eventually.

ECS is Amazon's service for orchestrating Docker containers (sort of Amazon's take on Docker Swarm I guess?). ECR is their version of Docker Hub, so you can store all your Docker images inside AWS. Great if your InfoSec people don't like the idea of data leaving controlled environments.

### SQS

Simple Queue Service

It's a queuing service. Don't really know what else to say about it? Nothing creative about the name. It was AWS's first available service though, way back in 2004, predating AWS itself by 2 YEARS!

OK, that's interesting.

### SNS & SES

Simple Notification Service & Simple Email Service

It sends notifications (think text messages), and emails. This is sort of writing itself at this point.

SNS will send emails, but SES gives you more control over the email content.

### Aurora & DynamoDB

Aurora is part of the RDS family, but is fully managed, so you don't get access to the underlying servers. It's both MySQL and PostgreSQL compliant. Either/or, not both at the same time. The name is Latin for "dawn".

Little bit of mental gymnastics here, but maybe they mean "dawn of a new database technology"?

DynamoDB is the next extension of AWS's DB offering. Dynamo is a NoSQL (Not Only SQL) database. It's largely cheaper to run than RDS/Aurora, and is fully serverless, but doesn't enforce referential integrity (see here for an explanation). So if you can work with that (and being honest, you probably can) go for DynamoDB.

The name is a derivative of the storage system Dynamo (reference). This in turn is probably based on a physical dynamo, which turns kinetic energy (rotation) into electricity. I can't work the link out, but it sounds cool

### Elasticache

AWS has two offering for caching services, both under the banner of Elasticache. Redis and Memcached. There are reasons why you'd use one over the other, but I'm not going to go into that here (use Redis if you value your sanity). Again a fairly traceable name. Cache because it's a cache, elastic because it implements elasticity in the same way the EC2 service does.

### Redshift

This is AWS's data warehousing solution, using columnar storage (most DB's are row-based, with the notable exception of SybaseIQ. Take 10 imaginary points if you've heard of that before).

The name is based on one of 2 things, and I can't find anything definitive to confirm either.

Option 1: Redshift is a physical phenomenon, and part of the doppler effect, where items getting further away appear red. This is usually due to expansion, so this could be the easy way you can expand the size of your redshift clusters.

Option 2: It's a swipe at Oracle, who have a red logo. The idea being that teams would shift away from Oracle.

Take your pick which you believe. I think option 2 is more likely, but because I'm a nerd I like option 1 more.

### Well-Architected Tool

This really dry name sits in front of a really useful tool (isn't that always the way?). The well-architected tool is AWS's attempt to automate some of the work their consultants were doing with their customers. Particularly around how best to setup their infrastructure against the well-architected framework:

- Operational Excellence
- Security
- Reliability
- Performance Efficiency
- Cost Optimization

### API Gateway

An API is an Application Programming Interface (but you knew that already, right?). API Gateway is an easy way to create and publish your API's, so that you can use them with other services (both AWS and not).

The upshot of using API Gateway, rather than self-hosting your API, is it talks natively to other AWS services, including Cloudwatch. Meaning that you can monitor your API service just like any other AWS hosted service. And it's PaaS.

### Cloudfront

Cloudfront is AWS's take on a CDN (Content Delivery Network. Can't get away from these definitions that use more acronyms. Symptom of the industry I guess?).

Cloudfront is pretty cool, because it's using AWS's existing (and massive) network of servers. It talks natively to other AWS services, so you can include the setup/teardown of your CDN with your web-app deployment. Or make your S3-based static site globally available with really low effort.

### Direct Connect

This creates a direct link between your data centre and the AWS backbone, so you're not talking over a VPN. This is significantly faster than a VPN, and more consistent — no more spikes at peak times.

### ASM

AWS Secrets Manager. To be fair this is usually just called Secrets Manager.

It manages secrets (key/pair usually) and allows you to refer to them via their ARN (Amazon Resource Name. I'm not defining ARNs any further because its not a tool as such). This gives you powerful options inside your resource stacks. Like not putting access keys or database passwords in source control, but referring to their ARN.

### ACM

AWS Certificate Manager

It manages SSL/TLS certificates. Like ASM but for certificates. Same advantages really. It's also one of two ways to attach SSL certificates to elastic load balancers. The other is via IAM, but ACM has a better interface & certificate rotation options, in my opinion.

### Shield

DDoS protection. Sort of what it says on the tin. Works on OSi layer 3 or 4 (OSi model), 24/7 coverage, with a human on the other end for when the heuristics fall over. Nice price protection too — stops you running up a massive scaling bill because you've been DDoS'd.

### WAF

Web Application Firewall. Firewall as a service at a basic level. At the advanced pricing level for Shield, this comes free. Which is nice.

### Storage Gateway

This is a piece of kit that you put in your existing datacentre. It gives you access to the storage services (EBS, EFS, S3, etc) using standard network file transfer protocols (SMB, NFS, iSCSI). Could be viewed as a stepping stone to getting into the cloud, but I think it's more aimed at being an easier backup solution.

Right. Break number two. Tea anyone?

## The more obscure (but still on the exam)

These are not common in early-phase cloud adoptions, but are on the "AWS-SA-Assoc" exam. A couple of the more interesting names here.

### Athena

Athena was (is?) the Greek goddess of wisdom, and the tool allows you to query files directing in S3, using SQL. Thus gaining wisdom?

### QuickSight

Quicksight is the graphing tool you can use on top of AWS Athena, to give quick (in)sight into your data.

### Glue

This is an ETL (Extract Transform Load) tool. ETL is used a lot when creating derived data sets (e.g. data aggregations). Essentially it's "gluing" data back together.

### Kinesis & Firehose

These are two different tools, but I've lumped them together because they're used together quite a lot.

Kinesis is (loosely) Greek for movement, and that's what it does. Moves data.

It comes in two forms Streams and Firehose.

Kinesis Streams take streaming data , lets you do transformations on the data, before outputting it. You could use this to dynamically change the content of a webpage as a user is interacting with it. Pretty cool huh?

Kinesis firehose allows you to continuously stream data from disparate inputs (like IoT devices) into either analytics tools (e.g. kinesis streams or custom lambdas) or S3.

### OpsWorks

OpsWorks allows you to run your existing chef (and puppet) code in your AWS account. I think it's called OpsWorks because in a traditional setup that's the work of an Ops team.

That's it. Simple. For once.

### Config

This monitors your AWS estate and gives you some control over the change management, and compliance monitoring. Handy when you have a regulator to worry about.

### Snowball & Snowmobile

These are cool. These are seriously cool.

They are variations on the theme of moving large amounts of data from an on-premises setup to AWS. The snowball is a box with a bunch of disks in and a shipping label. It connects to you network via Ethernet, and one type of snowball will do basic compute operations on the data whilst in-transit. The snowmobile is this, but bigger. Much bigger.

Comes with armed guards if you want them. Now bear with me whilst I pick my jaw up off the floor.

Last stretch now, hopefully the caffeine from the tea and coffee is still with you.

## The "Cool" ones (but not on the exam)

These are good fun. They also have a habit of showing up at places like re:invent with flashy demos.

### Polly

Want a cracker?

Amazon's text-to-speech service. Uses machine learning to make natural-ish sounding voices. Pops up in a few training courses for the AWS-SA-Assoc exams, because it's cool and makes an impact.

### DeepRacer

Deep learning & racing cars. Cool.

This is/was/will be the main feature of 2019's Re:Invent.

It's a cool way to get started with reinforcement learning, but I can't sell this better than Amazon can, so if you haven't already, take a look at it here.

### Sumerian

This was the language spoken in Sumer, and ancient mesopotamia (sort of where Iraq is now). How this turns into AR & VR with AWS I have no idea, but it does.

### Lumberyard

A lumberyard is an American term (I think, not heard it in the UK before) for somewhere you buy large amounts of wood (called lumber).

AWS's version is a game engine, for free, that integrates with Twitch (a game streaming platform that Amazon owns, but doesn't publicise that they do).

Lumberyard itself is free, which is cool. You pay for the AWS resources (S3, EC2, probably lambdas) that you use, on their own pay-as-you-use pricing models, so you can work out your costs pretty easily.

I don't actually write games, but if I did, I'd probably start with lumberyard. If only for the line in the licence that says:

> 57.10 Acceptable Use; Safety-Critical Systems. Your use of the Lumberyard Materials must comply with the AWS Acceptable Use Policy. The Lumberyard Materials are not intended for use with life-critical or safety-critical systems, such as use in operation of medical equipment, automated transportation systems, autonomous vehicles, aircraft or air traffic control, nuclear facilities, manned spacecraft, or military use in connection with live combat. However, this restriction will not apply in the event of the occurrence (certified by the United States Centers for Disease Control or successor body) of a widespread viral infection transmitted via bites or contact with bodily fluids that causes human corpses to reanimate and seek to consume living human flesh, blood, brain or nerve tissue and is likely to result in the fall of organized civilization.

Any service that has a zombie outbreak exemption is OK in my book.

## END!

Yep. Bored now. Hopefully you made it this far and found this at least remotely useful.

Like I said at the start (but it's worth saying again) reading this WILL NOT ensure you pass the AWS-SA-Assoc exam, but it might at least get a few of the tools to stay in your mind. Or maybe you'll start playing with DeepRacer — just watch your billing though!
