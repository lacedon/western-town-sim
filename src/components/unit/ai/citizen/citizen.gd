## This file should contain AI for the unit
## AI should be selected from enums in the unit resource
## AI file should expose a function to init the ai
## AI file should have a signal for changing the target where to go
## AI file should have a signal for changing animations from a common list of unit animations
## AI file should expose a function to let ai know the unit has reached the target
##
## Question 1: How do we handle fights?
## Question 2: How do we handle being in a building?
## Question 3: How do we handle mining resources?
## Question 4: How to detect areas?
## Question 5: How to handle if the target is an area?
## Question 6: What if the target is movable?
## Answer 1: ???
## Answer 2: AI targets the unit to entrance of the building and after that... ???
## Answer 3: AI targets the unit to the nearest point in area for mining and run mining animation
## Answer 4: ???
## Answer 5: ??? Do we really need to handle area? Maybe AI will select a random point in the area?
## Answer 6: AI should track the target

extends Node
