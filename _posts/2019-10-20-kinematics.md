---
layout: blogpost
title: Generalizing Kinematic Models to Novel Objects
description: ...for zero-shot manipulation.
image: /assets/images/generalizing-kinematics/doublewide.gif
excerpt_separator: <!--more-->
author: Ben Abbatematteo
day: October 21, 2019
---

Objects with articulated parts are ubiquitous in household tasks. Putting items in a drawer, opening a door, and retrieving a frosty beverage from a refrigerator are just a few examples of the tasks we'd like our domestic robots to be capable of. However, this is a difficult problem for present learning algorithms: refrigerators, for example, come in different colors, different shapes, are in different locations, etc, so policies trained on individual objects do not readily generalize to new instances of the same class.

Humans, on the other hand, learn to manipulate household objects with remarkable efficiency. As a child, we learn to interact with our refrigerator, then readily manipulate the refrigerators we encounter in the houses of our friends and relatives. This is because humans recognize the underlying task structure: these objects almost always consist of the same kind of parts, despite looking a bit different each time. In order for our robots to achieve generalizable manipulation, they require a representation of objects and their parts which directly facilitates interaction, and is readily computable at runtime for novel objects. This post details our recent work on training robots to generalize kinematic models to novel objects: after identifying kinematic models for many examples of an object class, our model learns to predict kinematic model parameters, articulated pose, object geometry, and kinematic state, ultimately enabling manipulation for novel instances of that class.

<!-- Humans, on the other hand, learn to manipulate household objects with remarkable efficiency. As a child, we learn to interact with our refrigerator, then readily manipulate the refrigerators we encounter in the houses of our friends and relatives.
For a robot, however, this is a difficult problem: the refrigerators are different colors, different shapes, are in different places, etc., and the agent naively fails to recognize the underlying task structure that allows humans to extrapolate so well. As such, attempting to learn these manipulation skills for a whole class of objects at the pixel level is prohibitively challenging. Our robots require a representation of objects and their parts which facilitates robust, generalizable manipulation, and is readily computable at runtime for novel objects. -->

<!--more-->  

## Kinematic Models

<!-- One such representation is a *kinematic graph* [cite], pictured below in Figure 1, which represents object parts as nodes in a graph, connected by edges detailing kinematic constraints between parts. For example, the cabinet pictured can be abstracted as the graph shown.  Edges in the graph consist of a) kinematic model type and b) kinematic model parameters. Model types are commonly revolute (like a door) or prismatic (like a drawer), but others exist as well (spherical, screw, etc.). Model parameters describe the objects forward kinematics: the position of each part as a function of the state of each joint. For example, in the revolute model, the parameters consist of a) the axis about which the part rotates and b) the spatial relationship between the axis and the origin of the part. These quantities describe the function which maps configuration (an angle in revolute mechanisms, and a displacement in prismatic mechanisms) to the position and orientation of a part. -->

*Kinematic models* are commonly used to represent the relative motion of two object parts. In particular, they describe the object's forward kinematics: the position and orientation of articulated part as a function of the *state* of a joint (the angle of a door or the displacement of a drawer, for example). The most common model types are revolute (like a door) or prismatic (like a drawer), but others exist as well (rigid, spherical, screw, etc). These models are parameterized by their position and orientation in space; for example, in the revolute model, the parameters consist of a) the axis about which the door rotates and b) the spatial relationship between the axis and the origin of the door. These quantities describe the function which maps state to the position and orientation of the articulated part.

A *kinematic graph* [cite] represents all of an object's parts and the kinematic models between them. Nodes in the graph represent the object's parts, and edges encode model types and model parameters. For example, in Figure 1, the cabinet pictured can be abstracted into three nodes and two edges, with the rotation between the door and the body encoded in the edge between the respective parts.

![kinematic graph](/assets/images/generalizing-kinematics/cabinet-graph.png)
*Figure 1: An example object and its corresponding kinematic graph, annotated with the pose of the axis of rotation.*

To summarize, each node in the graph represents a part, and each edge in the graph consists of:
1. Model type, denoted $$\mathcal{M}$$, between a part and its parent (revolute, prismatic, ...) .
2. Kinematic model parameters, $$\phi$$, the axis of rotation/translation, and the resting pose of that part.
3. The state (or *configuration*), denoted $$q$$, a joint angle in revolute models, and a displacement in prismatic models.

These quantities enable the robot to simulate how the object parts move about each other. If a robot can identify them, it can begin to manipulate the object using optimization or sample-based motion planning.

There's been a lot of research into fitting kinematic models to object motion either generated by a human demonstrator [cite] or by the robot itself [cite]. Critically, these approaches fit models to each object from scratch: a demonstration is required for every new object, no matter how similar each is to those experienced previously. This results in a robot which has to deliberately explore every object it encounters, without ever learning the underlying structure in its experiences. This is insufficient for a robot operating autonomously in a new household environment, where every object it sees will be new.

## Generalizing to New Objects

In contrast, our models are trained to predict kinematic model parameters from observations of static, novel objects. We choose to **categorize objects according to their part connectivity**; once we do so, if our agent can recognize objects, it can identify the kinematic graph which represents a novel instance. In particular, it will have the same connectivity as all other instances of that class. This enables us to define a template for each object class, then train neural network models which regress from depth images to the parameters of the kinematic models between each pair of parts. After being trained in simulation, the models are capable of predicting kinematic model parameters for real, novel objects from individual observations. We'll soon show that this is sufficient for manipulating new instances of familiar object classes without first seeing a demonstration.

### Dataset

In order to train these models, we need a source of annotated articulated objects. This dataset didn't exist when we began development. We built our own by procedurally generating objects from geometric primitives, simulating them in Mujoco [cite], rendering synthetic depth images, and recording ground truth parameters. We did so for six object classes: cabinet, drawer, microwave, toaster oven, two-door cabinet, and refrigerator. Note that we need to classify cabinets into two categories according to the number of articulated parts due to our classification scheme above. Ongoing work seeks to relax this by learning to identify part connectivity from pointclouds, too. Some samples from the dataset are shown in Figure 2.

<center>
  <img src="/assets/images/generalizing-kinematics/cartoon.gif"/>
</center>
*Figure 2: Sample simulated microwaves. The models trained on many examples of a class, then tested on novel instances.*


### Model
Ground truth parameters allowed us to train neural network models with supervised learning, but desired probabilistic output in order to allow the agent to express confidence in its estimates of model parameters, and to reason about sequential observations in a principled way. In order to do so, we trained mixture density networks [cite Bishop] ontop of ResNet-18 backbones. We trained one model for each class with observations from 10,000 objects. 

## Manipulating novel objects
We used the model to manipulate some real objects, as shown here.

[Paper]()
[Code]()
[Video]()


Outline:
Intro
  - motivate motivate motivate motivate  

Body 1
  - kinematic graphs
  - existing approaches

Body 2
  - Dataset development

Body 3
  - Model details

Body 4
  - Experiments

Conclusion
  - shit works, see me @ CoRL 2019 in Osaka.
