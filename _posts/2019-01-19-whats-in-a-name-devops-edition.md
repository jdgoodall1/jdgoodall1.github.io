---
layout: post
title: "What's In a Name? DevOps Edition"
date: 2019-01-19 09:00:00 -0500
author: Jon Goodall
categories: [DevOps, Tools]
tags: [devops, docker, jenkins, kubernetes, terraform, ansible, chef, puppet, kafka]
excerpt: "I've been working in DevOps for a while now, and I've yet to come across a tool that didn't have something odd about its name. It's either got a backstory, a meaning, or it's Greek. Let me translate them for you."
---

I've been working in DevOps for a while now, and I've yet to come across a tool that didn't have something odd about its name. It's either got a backstory, a meaning, or it's Greek. I don't know why, but I'd postulate that it's because the market is completely flooded with tools, and you need yours to stand out, so you can make money — either from the tool itself, or a support package.

With that in mind, I thought I'd translate them. In case you ever have the misfortune of having to explain to someone at C-Level ('C' as in CEO, not the swear word), why you're trying to install an octopus.

I've listed them here, and linked to the explanation, so you don't need to read the list. But please do, the stats are a great ego boost.

- [Docker](#docker)
- [Jenkins](#jenkins)
- [Bamboo](#bamboo)
- [Drone](#drone)
- [GoCD](#gocd)
- [Octopus Deploy](#octopus-deploy)
- [Ansible](#ansible)
- [Chef](#chef)
- [Puppet](#puppet)
- [TeamCity](#teamcity)
- [UrbanCodeDeploy](#urbancodedeploy)
- [Consul](#consul)
- [Vagrant](#vagrant)
- [Kafka](#kafka)
- [Kubernetes](#kubernetes)
- [Terraform](#terraform)
- [Vault](#vault)
- [Sentinel](#sentinel)

## Docker

**The tool:** creates, operates and managers containers.

**The meaning:** Containers are in a dock at some point. A "docker" is an occasional shorthand for someone that works at a dock, with containers.

## Jenkins

**The tool:** General purpose CI tool. CD was retconned into it with plugins that let you write pipelines (which I happen to quite like).

**The meaning:** Stereotypical name for a butler. Butlers run households and "get stuff done" in a general purpose sort of way. Not to be confused with a valet (essentially a male equivalent of a lady's maid). Also lots of creative definitions on UrbanDictionary, but I refuse to link to that (because no doubt someone will send me a bill for it).

## Bamboo

**The tool:** CI/CD tool from Atlassian. Works with other Atlassian tools (jira, bitbucket etc.) much better than other tools as a result.

**The meaning:** Fast growing plant, not very nutritious, pandas eat a lot of it — this one doesn't make sense to me.

## Drone

**The tool:** Yet another CI/CD tool. This one runs in Docker, with pipelines written in a version of docker compose. I guess you could call it "container native", if you like. They do.

**The meaning:** The proper name for most "worker" insects. And what every corporate employee feels like many times a day. Well, I do anyway.

## GoCD

**The tool:** ANOTHER CD TOOL. The odd names are making more sense now… (This definition is a little unfair, because it's actually a really good tool. Lots of built in functionality, runs on kubernetes really well.)

**The meaning:** It's written in GoLang. You could take it to mean "Go and do CD".

## Octopus Deploy

**The tool:** One of the few deployment specific tools (outside of a couple of DB deployment tools) that I've come across. The sales pitch is that it gets you away from writing massive scripts. This will do the "heavy lifting" for you. Not sure I buy that. Not sure they do either, as they have a method of writing pipelines as code.

**The meaning:** Feels like someone thought they were being clever with this one — "an octopus has tentacles, we'll call our remote agents tentacles". Nice Octopus graphics though.

## Ansible

**The tool:** Configuration management tool (there's a few of these in the list, and in essence they all let you determine the state of a server in code). Uses YAML (Yet Another Markup Language) file to store its config. Steps are executed sequentially by default, so ordering is simple.

**The meaning:** I think this one is quite clever, if you like science fiction.

> "The name of Ansible originally came from the book Rocannon's World by Ursula Le Guin, published in 1966. She used the word as the name of an instantaneous communication device that would allow contact over vast interstellar distances"
> — https://h2g2.com/edited_entry/A1165501

I don't know if that was the inspiration for the name, but I like to think it was.

## Chef

**The tool:** Configuration management tool. Steps in "recipes". Really nice interface.

**The meaning:** Chefs read cookbooks or create recipes to achieve the same end result each time (well, nearly. Depends on the restaurant. Hopefully the same isn't true here).

## Puppet

**The tool:** Configuration management tool (again). The IDE is called "geppetto", which is nice. (Geppetto made Pinocchio, in case you didn't know. I didn't until I looked it up).

**The meaning:** You control a puppet on a set of strings from elsewhere. Puppet itself though is the other way around most of the time, as the deployment targets ask for the changes.

## TeamCity

**The tool:** CI/CD tool from JetBrains (who make Intellij and a bunch of other tools).

**The meaning:** Erm. Right. No logic or clever backstory here that I could find. Seems like it was made to sell to large corporations — which to be honest, I can understand.

## UrbanCodeDeploy

**The tool:** IBMs' take on a deployment tool. The only tool I've found that doesn't have a free trial or download, so I couldn't try it out.

**The meaning:** I couldn't find any reason behind this one, so I think it's just a name.

## Consul

**The tool:** Key/Value store from Hashicorp. Nice CLI and API's. Also does service discovery, health-checking and DNS (via agents).

**The meaning:** This one makes absolutely no sense to me. A consul is an official appointed by a state to live in a foreign city and protect the states' interests there — e.g. they work at the consulate.

## Vagrant

**The tool:** Allows you to make quick and cheap virtual PC's on your existing physical PC. Saves you the pain of having to use VirtualBox/VMWare tools directly. Although you do still have to install them.

**The meaning:** Colloquialism for a wandering beggar. If you do a little mental gymnastics you can see where they were going with this — person of no fixed address, virtual PC with no permanent home.

## Kafka

**The tool:** Used for building realtime data streams.

**The meaning:** Apparently it's named after Franz Kafka.

## Kubernetes

**The tool:** Kubernetes is a "container orchestration tool". Which translates to it controls large amounts of containers

**The meaning:** Loosely translated from Greek as a helmsman, or habour pilot. Essentially a controller. Yes the spelling is a bit different, but you can see the logic here.

## Terraform

**The tool:** Infrastructure as code from HashiCorp. Lets you make anything in the major cloud providers, and manages their state. So that if someone changes something by hand, terraform can correct it.

**The meaning:** SciFi staple. Changing the environment to suit you. We (as in the species) might do it to Mars (the planet, not the chocolate) one day.

## Vault

**The tool:** Keeps data secure, only known people have the keys. Can seal/unseal/re-key. Various access policies

**The meaning:** Another analogy. Not a Hollywood vault with a big room behind 1 massive door, but more a vault with lots of safety deposit boxes in it. For a film reference I'd go with "The Bank Job (2008)".

## Sentinel

**The tool:** Policies as code. Works with other HashiCorp tools (enterprise version, you've got to pay for this one) to ensure that they are only used in a pre-defined manner. Lots of good examples on their website, go check it out.

**The meaning:** Sentinels guard or watch things to ensure that people don't do things they aren't meant to. Typically military personnel.

## Wrapping up

Right, that's it for now, because I've run out of brain. If you've made it to this point I'm impressed. If you've skimmed the list to see if there's a witty final statement "hi, *waves*". If you only wanted to see what Sentinel was and saw me waving, I don't blame you.

I'll try to post a follow up at some point as I find/try/use more tools — particularly ones with "odd" names. If there's any you've come across and I've missed, or if you have a better reason/definition for any I do have drop me a comment.

Hopefully this (very dry, quite boring) list saves you a bit of a headache, or gives you one, who knows. I promise next time I'll write about something interesting and maybe grind an axe for a bit.
