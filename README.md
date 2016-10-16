# SuperMarioBrobot
An excessively complicated, 'seeing' bot for Super Marios Bros. Senior Project CMSC498I

## Overview
A three component'd CV-Based learning system that plays (at the moment) Super Marios Bros and learns to play. This fits in the project specs because it counts as a classification. The core of this project (the one LSD wants the most) is the Learner.

### Inputs to Learner
Data from Reader - TBD
Output taken at this frame (LEARNING PORTION ONLY).

### Outputs from Learner (to Driver)
UP
DOWN
LEFT
RIGHT
A
UP + A
UP + A
DOWN + A
LEFT + A
RIGHT + A
B? Currently not sure if this is actually necessary to play the game.

## Three Components: Driver, Reader, Learner

### Driver
The LUA script that will interface with the emulator. Handles emulator-side actions. Will be hand-written

### Reader
Pre-existing tool, modified to fit the project. 
Candidates:
Tesseract OCR

### Learner
Built in Torch. Takes inputs from the Reader and the Driver to determine the next frame's action.
TODO:
Prototype inputs
Prototype outputs
