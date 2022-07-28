breed [late_rich late_folks]
breed [normal_people normal_folks]
breed [amenities amenity]
patches-own [
  patch_price
  ]
amenities-own [
 hood_income
  a_counter
  income]
normal_people-own
[income
counter_n
]
late_rich-own
[
income
counter

]
globals
[
our_income
hood_income_holder
]
to setup


 clear-all
  ask patches[set pcolor blue
   set patch_price 0.5

  ]


 create-amenities 1 [
    set shape "arrow"
    set heading 0
    set color 55
    set income 0
    set hood_income 0
    setxy random-xcor random-ycor
    too_close?
  ]

  create-amenities 1 [
    set shape "arrow"
    set heading 0
    set color 15
    set income 0
    set hood_income 0
    setxy random-xcor random-ycor
    too_close?
  ]
     create-amenities 3 [
    set shape "arrow"
    set color 0
     set heading 0
    set income 0
    set hood_income 0
    setxy random-xcor random-ycor
    too_close?

  ]

  patch_prices?

  create-normal_people (Population_Density * 10.89 )  [

 set shape "house"

    set income random_income
 class_selector
find_suitable_location


  ]


set hood_income_holder 0
set our_income 0
patch_price_amenity

end

to Go

ask normal_people[
    set counter_n 0]


  if (count turtles) > 475 [stop]

  ask patches [
    set patch_price 0.5]

  patch_prices?
  income_of_hood


patch_price_amenity


if count late_rich < 380 [
  every 1 [
   create-late_rich 2 [
 set shape "house"
    set income (random-normal 10 4)
 class_selector
 late_move
    ]
  ]

  every 3 [
   create-normal_people 1 [
 set shape "house"
    set income random_income
 set color 9
 class_selector
    ]
  ]
  ]


  upgrade_amenities?
  create_amenities?
  move?

end


to late_move

  if counter > 100 [die]
  set heading random 360
  fd random 15
  if (any? other turtles-here) [
    set counter counter + 1
    late_move
    set counter 0]

  ifelse patch_price_here >= 1 and patch_price_here < income / 2.2 [move-to patch-here ][late_move
    set counter counter + 1]



end

to-report random_income

     let %draw (random 50)
     if (%draw < 50 and %draw >= 10) [report (random-normal 2.5 0.3)]
      if (%draw < 10 and %draw >= 5 ) [report (random-normal 4.5 0.8)]
     if (%draw < 5 and %draw >= 2) [report (random-normal 8.0 2)]
     if (%draw < 2) [report (random-normal 12 2.5)]




;let rich (random-normal 3500 200)
;let poor (random-normal 1800 200)
; ifelse rich_or_poor? = true [
 ; set rich_or_poor? false
  ;  report rich] [ set rich_or_poor? true
   ; report poor]

 end

to too_close?
  if a_counter > 60 [die]
  if (count amenities in-radius 7 )> 1 [
    set a_counter a_counter + 1
    setxy random-xcor random-ycor
    too_close?]

   move-to patch-here


end

  to class_selector

 if income < 3.5 and income >= 1.5
  [   set color 0
  ;find_suitable_location
  ]

 if income >= 3.5 and income < 6
  [ set color 55
  ;  find_suitable_location
  ]


 if income >= 6 and income < 8.5
  [ set color 15
  ;  find_suitable_location
  ]


 if income >= 8.5 and income < 11
  [ set color 45
  ;  find_suitable_location
  ]


 if income >= 11
  [ set color 9.9
  ;  find_suitable_location
  ]


 if income <= 1.5
  [
    die]


end

to find_suitable_location

   if counter_n > 100 [die]
  set heading random 360
  fd random 15
  if ( any? other turtles-here)  [
  set counter_n counter_n + 1
    find_suitable_location]



ifelse patch_price_here < 1.5 * income and patch_price_here >= 1 [
    set counter_n 0
    move-to patch-here
  ]  [ set counter_n counter_n + 1
    find_suitable_location]



end

to-report patch_price_here
  ask self[
   ;show patch_price
  ]
  report patch_price
end

to patch_prices?


  ask patches [
    if (count amenities with [color = 0 ]in-radius 3.5) > 0 [

      set patch_price (1)

    ]

    if (count amenities with [color = 55 ]in-radius 3.5) > 0 [

      set patch_price (1.5)]

if (count amenities with [color = 15 ]in-radius 3.5) > 0 [

      set patch_price (2.5)]


if (count amenities with [color = 45 ]in-radius 3.5) > 0 [

      set patch_price (3.5)]

 if (count amenities with [color = 9.9 ]in-radius 3.5) > 0 [

      set patch_price ( 4.5)]


  ]


end

to upgrade_amenities?
   ask amenities with [color = 0] [
    if hood_income  > 130 [
      set color 55]

  ]


    ask amenities with [color = 55] [
    if hood_income  > 150 [
      set color 15]

  ]

     ask amenities with [color = 15] [
    if hood_income  > 170 [
      set color 45]



  ]

     ask amenities with [color = 45] [
    if hood_income  > 190 [
      set color 9.9]

  ]

end


to create_amenities?

  if count amenities with [color = 0] < 4 [


   create-amenities 1 [
    set shape "arrow"
    set heading 0
    set color 0
    set income 0
    setxy random-xcor random-ycor
    too_close?
  ]
  ]
end

to move?

  ask normal_people [

      if patch_price_here > income * 1.5 or patch_price_here < 1 [find_new_place]

  ]
end

to find_new_place

  set heading random 360
  fd random 20
  if ( any? other turtles-here) [find_new_place]

  ifelse (patch_price_here < (1.5 * income)) and (patch_price_here >= 1) [move-to patch-here] [find_new_place]


end




to income_of_hood

  foreach sort amenities [ income_calculator ->

    ask income_calculator [

    ask turtles in-radius 3.5 [
    set our_income our_income + income]
    set hood_income our_income
    set our_income 0
    ]

  ]



end

to patch_price_amenity

  foreach sort amenities [

    price_of_patch ->

   ask price_of_patch [

      set hood_income_holder (hood_income * 0.01 )

        ask patches in-radius 3.5[

                  set patch_price (patch_price + hood_income_holder)
                                  ]

 ]

]

end
