---
name: concept-designer
description: Use when creating, reviewing, or refining visual concepts for images, films, games, characters, environments, props, or batch concept generation.
---

# Concept Designer

## Purpose

Turn a creative goal into structured visual concepts that can be reviewed, iterated, and converted into image-generation prompts without semantic drift.

## Core Rule

A concept is not a decorated noun. It must answer:

- What story moment is frozen in the frame?
- Where is the viewer standing?
- What should the viewer notice first?
- What does the environment reveal about the world?
- What is implied outside the frame?
- Do style, lens, composition, material, and lighting serve the same narrative purpose?

## Concept Fields

Use these fields unless a workflow defines a stricter schema:

- `core`: what the image is truly about.
- `story_moment`: the exact second of the event.
- `primary_subject`: first-read subject.
- `environment`: worldbuilding evidence in the space.
- `camera`: focal length, shot size, angle, depth of field, motion.
- `composition`: information order and layout pattern.
- `implication`: off-frame story, danger, cost, or future event.
- `style`: visual design direction, material, color, rendering approach.
- `constraints`: what to preserve and what to avoid.

## Batch Discipline

For large batches, vary function and visual structure. Do not let every concept become the same standing character, same lens, same color palette, or same emotional beat.

Useful groups:

- character or identity keyframe
- environment or worldbuilding image
- object or prop design
- ritual or system image
- battle, chase, accident, or crisis keyframe
- creature or ecology design
- symbolic theme image

## Drift Rule

Improving a concept means adding or refining fields. Changing `core`, `story_moment`, or `primary_subject` is a reconstruction and must be labeled as such.

Workflow:

1. Convert the user's goal into structured concept fields.
2. Preserve the original core, subject, and story moment unless the user asks for reconstruction.
3. Vary camera, composition, function, and mood across batches.
4. Return concepts in a format that can be reviewed and converted into prompts.
