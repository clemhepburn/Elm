module Playground exposing (main)

import Html

weekday dayInNumber = 
  case dayInNumber of
    0 ->
      "Sunday"
    1 ->
      "Monday"
    2 ->
      "Tuesday"
    3 ->
      "Wednesday"
    4 ->
      "Thursday"
    5 ->
      "Friday"
    6 ->
      "Saturday"
    _ ->
      "Unknown Day"

hashtag dayInNumber = 
  case weekday dayInNumber of
    "Sunday" ->
      "#Sinday"
    
    "Monday" ->
      "#MondayBlues"

    "Tuesday" ->
      "#TakeMeBackTuesday"
    
    "Wednesday" ->
      "#HumpDay"
    
    "Thursday" ->
      "#ThrowbackThursday"
    
    "Friday" ->
      "#FlashbackFriday"
    
    "Saturday" ->
      "#Caturday"
    
    _ ->
      "#Whatever"


revelation =
  """
  It became very clear to me sitting out there today
  that every decision I've ever made in my entire life has
  been wrong. My life is the complete "opposite" of
  everything I  want it to be. Every instinct I have, 
  in every aspect of life, be it something to wear,
  something to eat - it's all been wrong.
  """

main =
  Html.text revelation

