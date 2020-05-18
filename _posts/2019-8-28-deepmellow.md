---
layout: blogpost
title: DeepMellow - Removing the Need for Target Networks in Deep Q-Learning
description: DeepMellow
author: Seungchan Kim
day: August 12, 2019
excerpt_separator: <!--more-->
---
In this paper, we proposed an approach to remove the need for a target network from Deep Q-learning. Our DeepMellow algorithm, the combination of Mellowmax operator and DQN, can learn stably without a target network when tuned with specific temperature parameter ω. We proved novel theoretical properties (convexity, monotonic increase, and overestimation bias reduction) of Mellowmax operator, and empirically showed that Mellowmax operator can obviate the need for a target network in multiple domains.

To learn more, see the full [blog post](https://seungchan-kim.com/2019/08/12/deepmellow-removing-the-need-for-a-target-network-in-deep-q-learning/), or read the [IJCAI paper](https://www.ijcai.org/proceedings/2019/0379.pdf).

<!--more-->
