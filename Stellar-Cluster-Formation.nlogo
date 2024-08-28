globals [
  gravity-constant
  time-step
  formation-threshold
  initial-gas-density
  star-formation-rate
  min-distance
  collision-probability
]

turtles-own [
  mass
  velocity
  acceleration
  age
  lifetime
  temperature
  is-binary
  binary-partner
]

patches-own [
  gas-density
]

to setup
  clear-all
  set gravity-constant 6.67430e-11
  set time-step 1
  set formation-threshold 0.1
  set initial-gas-density 1.0
  set star-formation-rate 0.01
  set min-distance 2.0
  set collision-probability 0.01
  setup-gas-clouds
  reset-ticks
end

to setup-gas-clouds
  ask patches [
    set gas-density initial-gas-density * (1 + random-float 0.5)
  ]
end

to go
  apply-turbulence
  calculate-forces
  update-motion
  update-gas-clouds
  manage-stellar-evolution
  handle-collisions
  tick
end

to apply-turbulence
  ask patches [
    set gas-density gas-density * (1 + (random-float 0.1 - 0.05))
  ]
end

to calculate-forces
  ask turtles [
    let force (list 0 0)
    ask other turtles [
      let dist distance myself
      if dist > 0 [
        let direction subtract-vectors (list xcor ycor) (list [xcor] of myself [ycor] of myself)
        let magnitude (gravity-constant * mass * [mass] of myself) / (dist * dist)
        set force add-vectors force scale-vector magnitude direction
      ]
    ]
    set acceleration scale-vector (1 / mass) force
  ]
end

to update-motion
  ask turtles [
    let new-velocity add-vectors velocity scale-vector time-step acceleration
    set velocity new-velocity
    let new-position add-vectors (list xcor ycor) scale-vector time-step new-velocity
    setxy item 0 new-position item 1 new-position
  ]
end

to update-gas-clouds
  ask patches [
    if gas-density > formation-threshold and random-float 1 < star-formation-rate [
      sprout-stars 1
      set gas-density gas-density * 0.9
    ]
  ]
end

to sprout-stars [num]
  sprout num [
    set shape "circle"
    set size 1
    set mass (random-normal 1 0.5)
    set velocity (list (random-float 2 - 1) (random-float 2 - 1))
    set acceleration (list 0 0)
    set age 0
    set lifetime (mass * 100)
    set temperature choose-temperature-based-on-age
    update-color-based-on-temperature
    set is-binary false
    set binary-partner nobody
  ]
end

to-report choose-temperature-based-on-age
  let temp 0
  if random-float 1 < 0.7 [
    set temp (random-float 4000 + 3000)
  ]
  if random-float 1 >= 0.7 and random-float 1 < 0.9 [
    set temp (random-float 3000)
  ]
  if random-float 1 >= 0.9 [
    set temp (random-float 5000 + 10000)
  ]
  report temp
end

to manage-stellar-evolution
  ask turtles [
    set age age + time-step
    if age > lifetime [
      die
    ]
  ]
end

to handle-collisions
  ask turtles [
    let nearby-collisions other turtles in-radius min-distance
    ask nearby-collisions [
      if random-float 1 < collision-probability [
        die
      ]
    ]
  ]
end

to update-color-based-on-temperature
  if temperature < 3000 [
    set color red
  ]
  if temperature >= 3000 and temperature < 5000 [
    set color orange
  ]
  if temperature >= 5000 and temperature < 6000 [
    set color yellow
  ]
  if temperature >= 6000 and temperature < 7500 [
    set color white
  ]
  if temperature >= 7500 [
    set color blue
  ]
end

to-report add-vectors [vec1 vec2]
  let result []
  (foreach vec1 vec2 [
    [?1 ?2] ->
    set result lput (?1 + ?2) result
  ])
  report result
end

to-report subtract-vectors [vec1 vec2]
  let result []
  (foreach vec1 vec2 [
    [?1 ?2] ->
    set result lput (?1 - ?2) result
  ])
  report result
end

to-report scale-vector [scalar vec]
  let result []
  (foreach vec [
    [?] ->
    set result lput (? * scalar) result
  ])
  report result
end
@#$#@#$#@
GRAPHICS-WINDOW
311
10
748
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
63
124
126
157
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
63
175
137
208
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
150
176
237
209
go-forever
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
62
20
234
53
star-form-rate
star-form-rate
0
0.1
0.01
0.001
1
NIL
HORIZONTAL

SLIDER
63
71
235
104
col-prob
col-prob
0
0.1
0.01
0.001
1
NIL
HORIZONTAL

MONITOR
62
234
167
279
Number of Stars
count(turtles)
0
1
11

PLOT
60
294
260
444
Number of Stars vs Time
Time
Stars
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Stars (total)" 1.0 0 -2674135 true "" "plot count turtles"

PLOT
58
471
258
621
Stellar Distribution
Groups
Number of Stars
0.0
7.0
0.0
100.0
true
true
"set-plot-x-range 0 7\nset-plot-y-range 0 count turtles\nset-histogram-num-bars 5" ""
PENS
"Red" 1.0 1 -2674135 true "" "plotxy 1 count turtles with [color = red]"
"Orange" 1.0 1 -955883 true "" "plotxy 2 count turtles with [color = orange]"
"Yellow" 1.0 1 -1184463 true "" "plotxy 3 count turtles with [color = yellow]"
"White" 1.0 1 -2758414 true "" "plotxy 4 count turtles with [color = white]"
"Blue" 1.0 1 -13345367 true "" "plotxy 5 count turtles with [color = blue]"

@#$#@#$#@
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
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
