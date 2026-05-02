---
layout: talk
title: "Keeping On-Call Human: AWS Serverless Slack After-Hours Alerts"
slug: keeping-on-call-human
date: 2026-04-22
event: "AWS Summit London"
location: "London, UK"
video_url: "https://www.youtube.com/watch?v=6FY8_qOttzw"
description: "A serverless system monitoring customer Slack channels out-of-hours (5:30pm-8:00am), sending low-severity alerts to on-call engineers to reduce wake-ups while maintaining visibility."
---

We built a serverless system monitoring customer Slack channels out-of-hours (5:30pm–8:00am), sending low-severity alerts to on-call engineers to reduce wake-ups while maintaining visibility.

This talk covers the AWS architecture — API Gateway, Lambda, SQS, DynamoDB TTL, and SNS — along with the reliability patterns that make it production-ready: signature validation, idempotency, deduplication, DLQs, retries, and CloudWatch observability.

You'll gain a reusable blueprint for smarter, human-friendly alerting.
