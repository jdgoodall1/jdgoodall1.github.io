---
layout: post
title: "AWS Database Savings Plans – Save Up to 35% – FINALLY!"
date: 2025-12-04 09:00:00 -0500
author: Jon Goodall
categories: [DevOps, Cloud, AWS]
tags: [aws, reinvent, database, savings-plans, cost-optimization, rds, aurora, dynamodb]
excerpt: "It's AWS Re:Invent right now, and one announcement has me and the rest of the AWS community very excited – AWS Database Savings Plans. I've been asking for this for as long as I can remember."
canonical_url: https://www.logicata.com/blog/aws-database-savings-plans/
image: /img/AWS-Database-Savings-Plans-1024x684.jpg
---

It's AWS Re:Invent right now, and one announcement has me and the rest of the AWS community very excited – AWS [Database Savings Plans.](https://aws.amazon.com/blogs/aws/introducing-database-savings-plans-for-aws-databases/)

I've been asking for this for as long as I can remember, probably because I'm a bit dull, and also a little stingy…

You're likely wondering why I'm so excited about this, and in no small part, it's because it makes my life easier. It also gives you, AWS customers, another AWS cost optimisation option to save money on your AWS bill, which is always a good thing.

Before we get into the details about AWS Database Savings Plans, let's do a bit of a history lesson.

## A History of AWS Savings Plans

All the way back in 2019 AWS released "[Compute Savings Plans](https://aws.amazon.com/savingsplans/compute-pricing/)", and I've been a fan since day 1. They make saving money on "compute" (namely, EC2, Fargate and later [Lambda](https://dev.to/aws-builders/aws-lambda-use-cases-when-you-should-use-it-5e2e)) much easier.

Before the Compute Savings Plan was released, if you knew that you were going to keep the same server for 1-3 years, you could lock in a commitment using a Reserved Instance (RI). Savings of 20% were common, and savings of 30% or more were possible. But, if you had plans on moving to "modern compute", you were a bit stuck. Sure, you could do it, but you'd be paying for the RI you'd committed to for the duration of the term, even if you weren't using it. This was a real barrier to modernisation, because nobody likes paying twice.

This is an oversimplification, as convertible Reserved Instances exist, which let you trade them for other types. Reserved Instances also "roll up" smaller-sized Reserved Instances to cover larger servers. This has a caveat, though – it only applies if there's no licence fee built into the hourly spend (sorry, Windows users). But in essence, you were stuck managing servers.

You could move to containers, but you had to keep using EC2 to run the containers on, which was a headache and added engineering time.

Compute Savings Plans are different, though – you commit to an hourly spend and save money. Literally, that's it.

OK, it's a spend within the three supported services (EC2, Lambda and Fargate), but so long as you're spending money on one of those things, you'd be getting the discounted pricing. Purchase terms are the same – commit to longer and pay more up front to save more money. However, the 0% upfront 1-year plan is incredibly compelling, so I default to recommending it.

Compute Savings Plans aren't perfect, though. My biggest gripe was that they didn't support database spend. You might argue it's a storage service, not a compute service, but tell a developer that. The line between "storage" and "compute" is so thin you can see through it at this point. My second biggest issue was the hourly commitment rather than the daily one. With a daily commitment you can account much better for flexible workload trends, but you can't have everything.

## Cool, history done, what's new?

As of the 2nd of December 2025, announced to great cheers from the audience in Matt Garman's re:Invent 2025 keynote, AWS Database Savings Plans are a thing! This is "A Very Good Thing". He really did save the best til last, with only 2 seconds left on the 'shot clock'!

AWS Database Savings Plans work in a very similar way to Compute Savings Plans – commit to an hourly spend in "supported usage" and save money.

Purchase terms are similar, but currently you can only commit to a 1-year term (come on AWS, give us 3 years!), and we're also only offered a no up-front payment option at lauch. I'd love to see increasing discounts available for committing for longer, and paying up front as you can with Compute Savings Plans. Despite this, there are still some serious discounts available here, and the best bit is it covers serverless too – with a discount of up to 35%! That's massive and really cements the idea for me that you should start on serverless options until your per-hour cost outweighs the "scale to zero" benefit. AWS are also pushing '[Advance Pay](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/manage-advancepay.html)' as a way to pay up front for your database services, but there's no discount for doing this, so I'm not sure why you'd bother.

They also have day 1 support in Savings Plan Purchase Analyzer – I waxed lyrical about this on an episode of the [Logicast AWS News Podcast](https://www.youtube.com/@logicata), so this is a really nice thing to have on day 1. You'd better believe if it didn't have it, I'd be complaining about it!

## Sounds Great, What's the Catch?

The AWS Database Savings Plan isn't a perfect offering, as it still suffers from my second gripe of Compute Savings Plans – the hourly vs. daily commitment.

It does also muddy the water a bit, as we now have four different types of Savings Plan:

- Compute Savings Plan
- EC2 Savings Plan
- Database Savings Plan
- SageMaker Savings Plan

This is very easy to solve though, AWS just needs to release an overall "Savings Plan" that covers Compute & Database, whilst dropping the EC2 Savings Plan offer. I've never found them useful between Reserved Instances and Compute Savings Plans, but maybe some people do. I also don't use SageMaker to have a considered opinion on SageMaker Savings Plans, so they get to stay for now.

I'm sure it's not very easy for AWS to do this, for a myriad of internal and technical reasons, but we can but dream.

Now, onto the "supported services" list. This is confusing. It covers:

- RDS
- Aurora
- DynamoDB
- ElastiCache
- DocumentDB
- Neptune
- Keyspaces
- Timestream
- Database Migration Service (who's running that for a whole year?).

This is a massive list of services for day 1 – remember Compute Savings plans only covered EC2 & Fargate at launch.

However, it's not all spend within those services that counts. Got a Redis cluster? Sorry, only Valkey is supported. Using a t4g RDS instance? No discount for you. In fact, anything that uses 'servers' is only eligible to be included in a Database Savings Plan if it's using the latest instance types (r7g, m7g, m7i, m8g, etc). This is very frustrating, as many people I've worked with need a 24/7 non-prod environment, but only need t4g instances, for example.

The serverless offering somewhat redeems this, as it's just per-CU (Capacity Unit) hour. This is a much better offering than the current option of "nothing" and goes a long way to solving for "I can't do serverless, it's more expensive under consistent load". This has been a real issue for me personally, as I'm a big advocate of serverless-first, but I couldn't honestly recommend it for production workloads. Either the warmup time was too long for transactional workloads, or the constant throughput was too expensive without being able to make a committed purchase.

## Final Thoughts on AWS Database Savings Plans

I'm willing to forgive the complicated in-scope vs. out-of-scope spend on this one, considering the vast array of services that are covered. Also this is a V1 offering so I'm sure it will evolve to include more services, and more payment options, as per the other savings mechanisms.

This also doesn't solve for "do I buy a Reserved Instance or an AWS Database Savings Plan", but the gap is closing, and I'm looking forward to seeing more things come into scope in the future. AWS have committed to including newly released instance types as they become available, so I'll just have to upgrade my boxes, I guess.
