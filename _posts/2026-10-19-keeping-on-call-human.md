---
layout: post
title: "Keeping On-Call Human: Serverless Out of Hours Alerting with AWS"
date: 2026-10-19 09:00:00 -0500
author: Jon Goodall
categories: [DevOps, AWS, Serverless]
tags: [aws, serverless, lambda, step-functions, sqs, slack, on-call, alerting, sns, eventbridge]
excerpt: "It's 2am, your phone is screaming. Most SREs have lived through it. Here's how I built a Slack bot backed by a few Lambdas and a Step Function to stop that happening unnecessarily."
canonical_url: https://builder.aws.com/content/3Kv85OEnuUmFKOlE0wYZCJyaj7e/keeping-on-call-human
---

## A Short Horror Story

It's 2am, your phone is screaming.

That's the most terrifying sentence I think any SRE will ever read. Problem is, most of them have lived through it — I know I have.

The trouble is, quite a lot of the time you didn't need to get out of bed to handle it.

## The Root Cause

The reasons this happens fall into two camps in my very painful experience.

**Type 1:** Planned maintenance you didn't know about.

**Type 2:** A problem with a pre-cursor alert you missed, because you get 170 different alerts a day, but this one happened to matter.

## The Solution?

Recently, I was lucky enough to be selected to talk at the AWS North Community Conference in Newcastle, and this was the topic of my talk — and the exact problem I faced at work as part of our 24/7 P1 response team.

So, what's the fix?

For "type 2" alerts, it's a case of "reduce the noise", and depending on your application and environment, the fix will be different. Whilst we've done a bit of work with "type 2" alerts, I was more interested in solving "type 1", which is what this article is about.

Turns out, in that case, the solution is a Slack bot backed by a few Lambdas. At least that's how I've solved it.

The architecture looks like this:

![Architecture diagram showing the Slack bot pipeline through API Gateway, Lambda, SQS, EventBridge Pipes, and a Step Function](/img/keeping-on-call-human-architecture.png)

On the face of it, it's pretty simple — but the complexity is hiding in the Step Function.

## Start to Finish: The Flow

1. Message written in Slack channel
2. Slack bot forwards the message to API Gateway via a webhook
3. API Gateway forwards that to the integration Lambda (assuming we're underneath the rate limit)
4. The integration Lambda checks the request header to make sure it's come from Slack, and passes it on to the SQS queue
5. EventBridge Pipes hands it to the Step Function
6. Magic happens (more Lambdas really)
7. Messages and maintenance windows get set in your on-call tool of choice

## Inside the Step Function

Inside the Step Function, we have a rather wide flow — but it's not doing anything very complicated. Most of the logic is exposed to the Step Function, rather than being hidden away inside the Lambdas. We did this intentionally because it makes observability a bit simpler (v1 of this had a lot more inside one large Lambda, which bothered me).

Again, start to finish we:

1. **Check if the channel is configured for automatic processing** — a nice bit of feature flagging, so we can turn this on or off for specific Slack channels.
2. **Check if we're in our defined "office hours" window** — we don't need to process the message if someone is going to see it anyway.
3. **Check if we've seen the message before** — we record all messages we process and store them for 1 hour, and we don't want to re-process anything if we can help it.
4. **Analyse the message using keyword analysis** — nothing agentic here, everything is fully deterministic. It helps that "planned deployment" or "scheduled maintenance" is a very small list of keywords to look for.
5. **Check if we've got all the other information we need** — timezone, start and end time, etc.
6. **If we think it's a deployment and we've got all the info**, make a maintenance window in Jira so we're not woken up when the website is taken offline for the deployment.
7. **If any of that fails**, or the checks result in us not having the information we need, we pass back to the current on-call engineer via an SNS integration. This feeds into a low-priority alerting system, so we're not sending high-priority alerts to prevent sending high-priority alerts later on.

When I give this talk in person, I wax lyrical about observability — CloudWatch logs, Metrics, X-Ray traces are all over this thing — and how that feeds into "trusting the system". But I think you get the idea without me going overboard.

## Did It Work?

Turns out, yes. Really well. Much better than I thought it was going to.

I don't have any hard data on this, because it's a broad and nebulous problem. What I do have is anecdotal evidence from the engineers using the system — me, and the people I work with. We're all in agreement that this has massively reduced the amount of stress staring at Slack in the evenings "just in case" something comes through, which is no mean feat.

As we find new failure modes we'll extend this, and tying this and a DevOps Agent together is on the roadmap — but in the current landscape of "agentic everything", I like the approach of "build a thing to solve a single problem", which we did.

---

*This article was originally published on [AWS Builder Center](https://builder.aws.com/content/3Kv85OEnuUmFKOlE0wYZCJyaj7e/keeping-on-call-human).*
