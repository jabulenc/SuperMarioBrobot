# SuperMarioBrobot
Computer Vision Convolutional Neural Network based runbot for Super Marios Bros. 
Senior Project CMSC498I

## Overview
Utilizes a CNN to analyze a play through frame-by-frame to determine input based on training data.

Models SMB as a 22-class problem, with 22 being the total number of human-possible input combinations, excluding Start and Select

### Architecture
Gen1: 3 Convolutional Layers and 1 FC Layer
Gen2: TODO: 3 Separate networks? Or 3 layers comprised of 3 layers each.

### Classification Scheme
To work within the confines of the assignment, we modeled the game as a n-class problem.

n was set to 4 (tenative) to represent the 4 button combinations that will induce need:
```
RA
R
A
START
```
