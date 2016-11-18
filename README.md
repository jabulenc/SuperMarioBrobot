# SuperMarioBrobot
Computer Vision Convolutional Neural Network based runbot for Super Marios Bros. 
Senior Project CMSC498I

## Overview
Utilizes a CNN to analyze a play through frame-by-frame to determine input based on training data.

Models SMB as a 22-class problem, with 22 being the total number of human-possible input combinations, excluding Start and Select

### Architecture
TODO

### Classification Scheme
To work within the confines of the assignment, we modeled the game as a n-class problem.

n was set to 26 (tenative) to represent the 22 button combinations that will induce movement in SMB:
```
ULAB
URAB
DLAB
DRAB
UAB
DAB
LAB
RAB
UA
UB
DA
DB
LA
LB
RA
RB
AB
U
D
L
R
A
B
START
SELECT
''
```

IDEA TODO: Average input guess over 15 frames and choose input from the highest of chosen. Inputs occur every quarter second. This should smooth things out.
