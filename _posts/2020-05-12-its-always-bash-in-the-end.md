---
layout: post
title: "It's Always Bash in the End"
date: 2020-05-12 14:00:00 -0500
author: Jon Goodall
categories: [DevOps, Scripting]
tags: [bash, cli, automation, aws, scripting, python, powershell]
excerpt: "I've been told by a few people that 'you don't need to know bash anymore'. No I haven't, that's a lie. No-one has told me that, because it isn't true. You absolutely need to understand bash."
image: https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=1200
---

![Coding](https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=1200)
*Photo by [Unsplash](https://unsplash.com/photos/boy-in-front-of-computer-monitor-vJP-wZ6hGBg)*

I've been told by a few people that "you don't need to know bash anymore". No I haven't, that's a lie. No-one has told me that, because it isn't true. You absolutely need to understand bash, the CLI, maybe Powershell (useful on Windows, but lately it's less important) and probably Python.

Why? **It's always bash in the end.**

Eventually you will be writing a bash script (or a hacky bash script, as a friend of mine aptly called them). There is just no avoiding it.

What's this I don't hear you cry? I'll just use a configuration management tool? Good idea, I like most of them, they make life a lot easier a lot of the time. But let's be honest? They're basically a wrapper around bash. Or Python.

## A Concrete Example

Let's use a concrete example. I had (well, inherited) a task to get regular snapshots taken, of an Amazon EC2 instance, which was hosting a MySQL DB. I also needed to age them out, because we only needed to keep a few days worth.

I'll walk you through my thought process.

### Step 1: Why aren't we using RDS? 
This stuff is handled.

### Step 2: Ah, multiple replication sources, damn. 
Let's use lifecycle rules, 50 lines of terraform handles the whole thing.

### Step 3: Oh, can't do that
I need to flush logs and set read locks. Right, custom script. Ansible anyone?

### Step 4: Ah, there isn't a module for "create snapshots" 
(there is one for snapshotting an EBS volume, but not for doing all the volumes attached to an instance, at least not when I was doing this). I guess I'm using the AWS CLI.

### Step 5: Bash script
Cron to run it, with a cron monitor (lots are available, I'm not advertising any here as they're not paying me).

### Step 6: Profit 
(well, continue to draw a salary, but that's close, right?).

## The Point

So what's the message here? I'm a really good engineer? Well my ego would say yes, but no, that's not the point. 

The point is I ran through 4 layers of "modern" options, from fully managed to IaaS, and ended up writing a script in a language from 1989.

How about that?
