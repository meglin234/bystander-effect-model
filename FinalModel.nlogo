extensions [ csv table]
globals [event-patch prox-patches not-patches stop-patches
         num-bystanders event-data indv-data byst
         time dist density day location snap c]
breed [bystanders bystander]
breed [interveners intervener]
interveners-own [id proximity action-type]


; procedure to load in csv event data
to load-event-csv
  if not file-exists? "EventData.csv"
    [; error handling if file not found
      user-message "File not found"
      stop
     ]
  file-open "EventData.csv" ; open the file
  set event-data []  ; important to initialize this variable as a list
  while [ not file-at-end? ] [
    set event-data lput csv:from-row file-read-line event-data
  ]
  file-close
end


; procedure to load in csv individual data
to load-individual-csv
  if not file-exists? "AllIndividualDataNew.csv"
    [; error handling if file not found
      user-message "File not found"
      stop
     ]
  file-open "AllIndividualDataNew.csv" ; open the file
  set indv-data []  ; important to initialize this variable as a list
  while [ not file-at-end? ] [
    set indv-data lput csv:from-row file-read-line indv-data
  ]
  file-close
end


to setup
  load-event-csv
  load-individual-csv
  ask turtles [die]
  set-event-variables
  set event-patch patch 0 0
  ask event-patch
  [ set pcolor 1 ]
  set-proximity-patches
  generate-bystanders
  generate-interveners
  set-current-plot "Action Type"
     clear-plot
  reset-ticks
end

; procedure to create patches for close proximity interveners
to set-proximity-patches
  ask patch 0 1 [ set pcolor 1 ]
  ask patch 0 2 [ set pcolor 2 ]
  ask patch 0 3 [ set pcolor 2 ]
  ask patch 0 4 [ set pcolor 2 ]
  ask patch 0 -1 [ set pcolor 1 ]
  ask patch 0 -2 [ set pcolor 2 ]
  ask patch 0 -3 [ set pcolor 2 ]
  ask patch 0 -4 [ set pcolor 2 ]
  ask patch -1 0 [ set pcolor 1 ]
  ask patch -2 0 [ set pcolor 2 ]
  ask patch -3 0 [ set pcolor 2 ]
  ask patch -4 0 [ set pcolor 2 ]
  ask patch -2 -1 [ set pcolor 2 ]
  ask patch -3 -1 [ set pcolor 2 ]
  ask patch -4 -1 [ set pcolor 2 ]
  ask patch -1 -2 [ set pcolor 2 ]
  ask patch -3 -2 [ set pcolor 2 ]
  ask patch -4 -2 [ set pcolor 2 ]
  ask patch -2 -3 [ set pcolor 2 ]
  ask patch -2 -4 [ set pcolor 2 ]
  ask patch -3 -4 [ set pcolor 2 ]
  ask patch -4 -3 [ set pcolor 2 ]
  ask patch -2 -2 [ set pcolor 2 ]
  ask patch -3 -3 [ set pcolor 2 ]
  ask patch -4 -4 [ set pcolor 2 ]
  ask patch -1 -1 [ set pcolor 1 ]
  ask patch -1 -2 [ set pcolor 2 ]
  ask patch -1 -3 [ set pcolor 2 ]
  ask patch -1 -4 [ set pcolor 2 ]

  ask patch -1 1 [ set pcolor 1 ]
  ask patch -1 2 [ set pcolor 2 ]
  ask patch -1 3 [ set pcolor 2 ]
  ask patch -1 4 [ set pcolor 2 ]
  ask patch -2 1 [ set pcolor 2 ]
  ask patch -2 2 [ set pcolor 2 ]
  ask patch -2 3 [ set pcolor 2 ]
  ask patch -2 4 [ set pcolor 2 ]
  ask patch -3 1 [ set pcolor 2 ]
  ask patch -3 2 [ set pcolor 2 ]
  ask patch -3 3 [ set pcolor 2 ]
  ask patch -3 4 [ set pcolor 2 ]
  ask patch -4 1 [ set pcolor 2 ]
  ask patch -4 2 [ set pcolor 2 ]
  ask patch -4 3 [ set pcolor 2 ]
  ask patch -4 4 [ set pcolor 2 ]


  ask patch 1 0 [ set pcolor 1 ]
  ask patch 2 0 [ set pcolor 2 ]
  ask patch 3 0 [ set pcolor 2 ]
  ask patch 4 0 [ set pcolor 2 ]
  ask patch 1 1 [ set pcolor 1 ]
  ask patch 2 1 [ set pcolor 2 ]
  ask patch 3 1 [ set pcolor 2 ]
  ask patch 4 1 [ set pcolor 2 ]
  ask patch 1 2 [ set pcolor 2 ]
  ask patch 2 2 [ set pcolor 2 ]
  ask patch 3 2 [ set pcolor 2 ]
  ask patch 4 2 [ set pcolor 2 ]
  ask patch 1 3 [ set pcolor 2 ]
  ask patch 2 3 [ set pcolor 2 ]
  ask patch 3 3 [ set pcolor 2 ]
  ask patch 4 3 [ set pcolor 2 ]
  ask patch 1 4 [ set pcolor 2 ]
  ask patch 2 4 [ set pcolor 2 ]
  ask patch 3 4 [ set pcolor 2 ]
  ask patch 4 4 [ set pcolor 2 ]

  ask patch 1 -1 [ set pcolor 1 ]
  ask patch 2 -1 [ set pcolor 2 ]
  ask patch 3 -1 [ set pcolor 2 ]
  ask patch 4 -1 [ set pcolor 2 ]
  ask patch 1 -2 [ set pcolor 2 ]
  ask patch 2 -2 [ set pcolor 2 ]
  ask patch 3 -2 [ set pcolor 2 ]
  ask patch 4 -2 [ set pcolor 2 ]
  ask patch 1 -3 [ set pcolor 2 ]
  ask patch 2 -3 [ set pcolor 2 ]
  ask patch 3 -3 [ set pcolor 2 ]
  ask patch 4 -3 [ set pcolor 2 ]
  ask patch 1 -4 [ set pcolor 2 ]
  ask patch 2 -4 [ set pcolor 2 ]
  ask patch 3 -4 [ set pcolor 2 ]
  ask patch 4 -4 [ set pcolor 2 ]

  set prox-patches patches with [ pcolor = 2 ]
  set not-patches patches with [ pcolor = 0 ]
  set stop-patches patches with [ pcolor = 1 ]

end

; procedure to setup the environment
to set-event-variables
  foreach event-data ;for each row in event-data
      [ row  ->  if (item 1 row = number-of-bystanders) [
        set byst item 2 row
        set density item 5 row
        set time item 6 row
        set day item 7 row
        set location item 8 row ]
  ifelse density = "high" [ ; set the display size for high density events
          if byst < 11 [
            resize-world -5 5 -5 5
            set-patch-size 48 ]
          if byst > 11 and byst < 21 [
            resize-world -6 6 -6 6
            set-patch-size 40 ]
          if byst > 21 and byst < 27 [
            resize-world -7 7 -7 7
            set-patch-size 35 ]
          if byst > 30 and byst < 35 [
            resize-world -8 8 -8 8
            set-patch-size 31 ]
          if byst = 44 [
            resize-world -10 10 -10 10
            set-patch-size 25 ]
        ] [                ; set the display size for low density events
          if byst < 11 [
            resize-world -10 10 -10 10
            set-patch-size 25 ]
          if byst > 11 and byst < 21 [
            resize-world -11 11 -11 11
            set-patch-size 23 ]
          if byst > 21 and byst < 27 [
            resize-world -12 12 -12 12
            set-patch-size 21 ]
          if byst > 27 and byst < 35 [
            resize-world -14 14 -14 14
            set-patch-size 18 ]
          if byst > 35 [
            resize-world -15 15 -15 15
            set-patch-size 17 ]
        ]
  ]
end

; procedure to create bystanders
to generate-bystanders
  foreach event-data
      [ row  ->  if (item 1 row = number-of-bystanders)
        [create-bystanders item 3 row [
          set color 7 set size 1 set shape "circle" move-to one-of patches ]
        ]
  ]
end

; procedure to create interveners
to generate-interveners
  foreach indv-data ; for each row in individual-data
      [ row  ->  if (item 1 row = number-of-bystanders)
        [create-interveners 1 [
            set id item 2 row
            set color 7
            set size 1
            set shape "circle"
            set proximity item 5 row
            if proximity = 1 [ move-to one-of prox-patches ]
            if proximity = 0 [ move-to one-of not-patches ]
        ]
     ]
  ]
end

; procedure to "turn on" interveners
to set-interveners
  foreach indv-data
      [ row  ->  if (id = item 2 row)
        [ set id who
          set color item 7 row
          set shape item 3 row
        ]

        if color = 16  [ set action-type "esc" ]
        if color = 86  [ set action-type "de-esc" ]
        if color = 67  [ set action-type "both" ]
        if color = 9.9 [ set action-type "none" ]
        ]
end


to go
if ticks > 10 and not any? interveners-on prox-patches and not any? interveners-on not-patches
  [ stop ]
ask event-patch [
    if ticks > 9 [
      set pcolor yellow ]
  ]

ask bystanders [
  if ticks > 10 [
      set shape "x" ]
  ]

;different movement for different locations
  if location = "inside bar"        [ move-inside-bar ]
  if location = "outside bar"       [ move-outside-bar ]
  if location = "public street"     [ move-public-street ]
  if location = "station"           [ move-station ]
  if location = "shop/restaurant"   [ move-shop ]

  tick
end

; procedure to move if location inside-bar
to move-inside-bar
  if ticks < 10 [
    ask turtles [
      rt random 360 fd .3 ]
  ]
if ticks = 10 [
    ask interveners [
      set-interveners
    ]
  ]
if ticks > 10 [
   ask bystanders [ rt random 360 fd .3 ]
   ask interveners [
      set heading (towards event-patch)
      fd 1
    ]
  ]
end

; procedure to move if location outside-bar
to move-outside-bar
  if ticks < 10 [
    ask turtles [
      rt random 270 fd 1 ]
  ]
if ticks = 10 [
    ask interveners [
      set-interveners
    ]
  ]
if ticks > 10 [
   ask bystanders [ rt random 270 fd 1 ]
   ask interveners [
      set heading (towards event-patch)
      fd 1
    ]
  ]
end

; procedure to move if location public-street
to move-public-street
  if ticks < 10 [
    ask turtles [
      rt random 90 fd 2 ]
  ]
if ticks = 10 [
    ask interveners [
      set-interveners
    ]
  ]
if ticks > 10 [
   ask bystanders [ rt random 90 fd 2 ]
   ask interveners [
      set heading (towards event-patch)
      fd 1
    ]
  ]
end

; procedure to move if location station
to move-station
  if ticks < 10 [
    ask turtles [
      rt random 180 fd .5 ]
  ]
if ticks = 10 [
    ask interveners [
      set-interveners
    ]
  ]
if ticks > 10 [
   ask bystanders [ rt random 180 fd .5 ]
   ask interveners [
      set heading (towards event-patch)
      fd 1
    ]
  ]
end

; procedure to move if location shop/restaurant
to move-shop
  if ticks < 10 [
    ask turtles [
      rt random 360 fd .2 ]
  ]
if ticks = 10 [
    ask interveners [
      set-interveners
    ]
  ]
if ticks > 10 [
   ask bystanders [ rt random 360 fd .2 ]
   ask interveners [
      set heading (towards event-patch)
      fd 1
    ]
  ]
end


; procedure to take a snapshot of interveners before they have moved
to snap-shot
  ask event-patch [
      set pcolor yellow
  ]
  ask interveners [
      set-interveners
  ]
  ask bystanders [
    set shape "x"]
  update-plot
end

; procedure to update Action Type plot
to update-plot
  set-current-plot "Action Type"
  clear-plot

  let counts table:counts [ action-type ] of interveners
  let actions sort table:keys counts
  let n length actions
  set-plot-x-range 0 n
  set-plot-y-range 0 count interveners
  let step 0.001 ; no gaps
  (foreach actions range n [ [s i] ->
    let y table:get counts s
    if s = "de-esc" [ set c 86 ]
    if s = "esc" [ set c 16 ]
    if s = "both" [ set c 67 ]
    if s = "none" [ set c 8 ]
    create-temporary-plot-pen s
    set-plot-pen-mode 1 ; bar mode
    set-plot-pen-color c
    foreach (range 0 y step) [ _y -> plotxy i _y ]
    set-plot-pen-color black
    plotxy i y
    set-plot-pen-color c ; to get the right color in the legend
  ])
end
@#$#@#$#@
GRAPHICS-WINDOW
378
13
911
547
-1
-1
21.0
1
10
1
1
1
0
0
0
1
-12
12
-12
12
0
0
1
ticks
30.0

BUTTON
189
22
266
55
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
280
21
357
54
go
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

MONITOR
13
72
115
117
total interveners 
count interveners
2
1
11

MONITOR
131
71
252
116
percent interveners
(count interveners / byst) * 100
2
1
11

CHOOSER
12
15
173
60
number-of-bystanders
number-of-bystanders
1 "2a" "2b" "2c" 3 "4a" "4b" "4c" "5a" "5b" "5c" "5d" 6 "7a" "7b" "7c" "7d" 8 "9a" "9b" "9c" 10 11 "12a" "12b" 13 14 "15a" "15b" "15c" "16a" "16b" 17 "18a" "18b" "20a" "20b" "20c" "22a" "22b" 23 "24a" "24b" "26a" "26b" 28 "30a" "30b" 31 34 40 42 44 57 76
44

MONITOR
14
172
78
217
NIL
density
17
1
11

MONITOR
211
173
280
218
NIL
day
17
1
11

MONITOR
291
173
355
218
NIL
time
2
1
11

MONITOR
89
172
201
217
NIL
location
17
1
11

MONITOR
62
388
170
433
percent male
((count interveners with [shape = \"circle\"] + count interveners with [shape = \"circle 2\"]) / count interveners) * 100
2
1
11

MONITOR
63
331
170
376
percent female
((count interveners with [shape = \"square\"] + count interveners with [shape = \"square 2\"]) / count interveners) * 100
2
1
11

MONITOR
63
274
171
319
percent bouncers
((count interveners with [shape = \"triangle\"] + count interveners with [shape = \"triangle 2\"]) / count interveners) * 100
2
1
11

BUTTON
266
77
359
110
snapshot
snap-shot
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
18
141
356
160
----------------Environment----------------
14
0.0
1

TEXTBOX
16
239
357
273
---------------Intervener Data--------------
14
0.0
1

TEXTBOX
23
394
48
425
⬤
18
1.0
1

TEXTBOX
21
279
46
309
▲
24
1.0
1

TEXTBOX
17
334
51
372
◼
32
1.0
1

PLOT
187
274
369
433
Action Type
action
count
0.0
10.0
0.0
10.0
true
false
"" "if ticks > 11 [ update-plot ]\n"
PENS

TEXTBOX
185
423
244
495
▬
60
86.0
1

TEXTBOX
229
423
286
494
▬
60
86.0
1

TEXTBOX
292
423
346
494
▬
60
16.0
1

TEXTBOX
313
423
368
494
▬
60
16.0
1

TEXTBOX
194
460
278
478
de-escalatory
12
0.0
1

TEXTBOX
301
460
363
478
escalatory 
12
0.0
1

TEXTBOX
211
467
266
538
▬
60
67.0
1

TEXTBOX
303
468
360
539
▬
60
8.0
1

TEXTBOX
226
505
259
523
both
12
0.0
1

TEXTBOX
317
506
350
524
none
12
0.0
1

MONITOR
16
510
178
555
close proximity to event
count interveners with [ proximity = 1 ]
2
1
11

MONITOR
75
447
172
492
knows party
(count interveners with [shape = \"triangle 2\"]) + (count interveners with [shape = \"square 2\"]) + (count interveners with [ shape = \"circle 2\" ])
17
1
11

TEXTBOX
10
448
72
494
 ◯ ▢ 
20
0.0
1

TEXTBOX
25
464
51
494
△
24
0.0
1

@#$#@#$#@
## WHAT IS IT?

This model is a representation of the bystander effect. The bystander effect is a social psychological theory that states that individuals are less likely to offer help to a victim when other people are present.

## HOW IT WORKS

The user can select the number of bystanders present. The model uses data from violent incidents captured on CCTV in Copenhagen, Denmark, to show what percentage of bystanders intervene, each intervener's demographic information, and details about the environment. The data is accessed from two CSV files.  

At the start, all bystanders move randomly. Then after ten ticks, a yellow patch will appear in the center of the screen, signifying a violent event. Once the event occurs, any bystanders who have decided to intervene will change shape and color, depending on their individual traits, and head toward the event. Any bystanders who decide not to intervene become X's and continue to move about randomly. 

## HOW TO USE IT

The number-of-bystanders dropdown menu allows the user to select the number of bystanders present in a given run. Since the model is showing actual events with real people that happened in Denmark, there is more than one event for some number of bystanders. These cases are denoted by having a letter after the number of bystanders (i.e., 7a, 7b, 7c). 

Once the number-of-bystanders is selected, the user can set up the model and run it using the "go" button or take a snapshot using the "snapshot" button. Using "go" will run the model in full. First, all of the bystanders move randomly, and after ten ticks, the yellow event patch will turn on, signifying the violent event. Once the event occurs, any bystanders who have decided to intervene will change shape and color, depending on their individual traits, and head toward the event. Any bystanders who decide not to intervene become X's and continue to move about randomly. The model stops after all interveners are within one meter of the event patch. 

Since having all the interveners within a meter of the event patch might make it hard to determine their individual traits, there is also a snapshot option. Using "snapshot" will activate the event patch, turn on the interveners' traits, and change the shape of bystanders who remain bystanders to X's. However, "snapshot" will not allow any bystanders to move, essentially freezing the model or taking a snapshot of the situation before the interveners actually intervene. 

-----------------------------------------------------------------------------------------

Intervener Shape, Color, and Fill

Shape = Gender
triangle = bouncer 
square   = female 
circle   = male

Color = Action 
blue  = de-escalatory
red   = escalatory
green = both
gray  = none 

Fill = Social Relationship
filled in = stranger
no fill   = knows a party member

-----------------------------------------------------------------------------------------

The total interveners monitor shows the total number of people who intervened, and the percent interveners monitor shows the percent of people who decided to intervene. The density monitor shows the density of the crowd for the event. The location monitor shows the location of the event. The day monitor shows the day of the week the event took place, and the time monitor shows the time of day the event took place. 

Both the density and location of the event affect how the model is set up. Although the display size stays the same, high-density events have fewer patches within the display, causing the agents to be greater in size and, therefore, closer together. The location of the event affects the movement of the agents. 

inside bar      -  speed = .3 , rotation = 360
outside bar     -  speed = 1  , rotation = 270
public street   -  speed = 2  , rotation = 90
station         -  speed = .5 , rotation = 180
shop/restaurant -  speed = .2 , rotation = 360


The percent bouncers monitor shows the percentage of interveners who are bouncers. The percent female monitor shows the percentage of interveners who are women. The percent male monitor shows the percentage of interveners who are men. The knows party monitor shows the number of interveners who have a social relationship with one of the people involved in the event. The close proximity to event monitor shows the number of interveners who were within a two-meter radius of the event when the event occurred. 

The Action Type plot shows the distribution of the types of actions interveners took in response to the event. The Y-axis is the number of interveners who took action, and the X-axis is the type of action. 


## THINGS TO NOTICE

The percentage of interveners generally decreases as the number of bystanders increases. Additionally, there are more male interveners than female interveners, and male interveners took more overall actions, especially escalatory actions. On the other hand, when bouncers were present, they took action in the majority of the cases, and their actions were largely de-escalatory. 

## THINGS TO TRY

Try adjusting the number of bystanders present and see how it affects the percent of interveners. 

## EXTENDING THE MODEL

Due to the nature of the data, the user can only select the number of bystanders, but future versions of this model might try to expand on the user interactions. Allowing the user to customize the environment and event details would allow for greater exploration of the bystander effect.   

## NETLOGO FEATURES

The CSV extention was used. 

## CREDITS AND REFERENCES

Liebst, L. S., Philpot, R., Bernasco, W., Dausel, K. L., Ejbye-Ernst, P., Nicolaisen, M. 		H., & Lindegaard, M. R. (2019). Social relations and presence of others predict 		bystander intervention: Evidence from violent incidents captured on CCTV. 			Aggressive behavior, 45(6), 598–609. https://doi.org/10.1002/ab.21853

link to raw data: https://mfr.osf.io/render?url=https://osf.io/8wk4d/?direct%26mode=render%26action=download%26mode=render
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
NetLogo 6.2.2
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
