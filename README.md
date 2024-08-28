# Stellar-Cluster-Formation Model Info

## WHAT IS IT?

Hello! This model aims to emulate the formation and evolution of a stellar cluster. It demonstrates how stars are born from gas clouds, interact through gravitational forces and evolve over time. It is a simplified version that hopes to reflect the dynamics observed in real stellar clusters. 

## HOW IT WORKS

### Agents
The following are the main agents active in the model:
  * **Stars**: Stars are the primary agents in the model. They move through space influenced by gravitational forces from other stars. Stars are initialised with properties like mass, velocity, temperature, age and lifespan. 
  * **Gas clouds**: Gas clouds are regions of active stellar formation. They can form stars when their density exceeds a certain threshold value.

### Rules:
These are the general rules governing the agents' actions:
  * **Gravitational Interaction**: Stars exert gravitational forces on each other, influencing their motion. This is done based on Newton's law of Gravitation.
  * **Movement**: Stars move according to their velocities and gravitational interactions.
  * **Star Formation**: Gas in the gas clouds collapse under certain thermonuclear conditions to form stars.
  * **Stellar Evolution**: Stars age over time and eventually reach the end of their lifecycle and die.
  * **Collision Handling**: Collisions between stars are managed based on proximity and collision probability.

## HOW TO USE IT

Here are the controls you'll find in the Interface tab and what each of them mean:

  * **star-form-rate**: Controls how frequently new stars are formed from gas clouds
  * **col-prob**: Adjusts the probability of collisions occuring when stars are within minimum distance
  * **setup**: Initialises the model
  * **go-once**: Run the model for 1 tick
  * **go-forever**: Run the model continuously until stop
  * **Number of Stars**: Track the current number of stars in the environment
  * **Number of Stars vs Time**: Plots the number of stars over time
  * **Stellar Distribution**: Plots the number of stars of each class (H-R diagram)

## THINGS TO NOTICE

Certain interesting patterns emerge over time while running the model. You can observe the overall stellar dynamics, from formation to interactions (although simplified). Key features like how stars form from gas clouds, the distribution of star temperatures (classes) over time, how gravitational interactions affect the movement and clustering of stars and the gradual aging, evolution and death of stars. 

## THINGS TO TRY

To get you started with the model, here are a couple things you can try:

  * Adjust the star formation rate using the slider and see how the cluster evolves with more or fewer newer stars.
  * Adjust the collision probability settings using the slider to explore how that affects star collisions and interactions.
  * Try varying the gas cloud properties to observe the impact on star formation rates and evolution. 

## EXTENDING THE MODEL

I had a lot of ideas I mean to implement with the model. One interesting features I wished to explore was **introducing binary star systems**. Since binaries have unique orbital dynamics, their movement and thus interactions would add complexity to the model. I have made provisions for this by including the turtle properties - is-binary and binary-partner. 

Another feature I had hoped to explore was **simulating sub-clusters**. By creating separate groups of stars with different densities within the cluster, it would be interesting to observe how they interact and merge over time.

Some other not-so concrete ideas are including proper stellar lifecycle behaviour (from red giant to white dwarf say), accounting for after-collision behaviour and many, many more. The possibilities are endless with this model! 

## NETLOGO FEATURES

Since this model was made as part of the course - **Introduction to Agent-Based Modelling**, I tried to explore certain new and old concepts taught in the course. I used custom vector operations to handle gravitational forces and resulting star movements. I have also implemented a dynamic colour mapping based on star temperatures to reflect their real-life colour variations. 

## RELATED MODELS

I found the Flocking model and Ants model to be somewhat similar to what is being done here.

## CREDITS AND REFERENCES

I drew inspiration from Matthew Bate's "Large Star Cluster Formation in 3D".
http://www.astro.ex.ac.uk/people/mbate/Cluster/cluster3d.html
