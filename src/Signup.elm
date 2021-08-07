module Signup exposing (User)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias User =
  { name : String
  , email : String
  , password : String
  , loggedIn : Bool
  }

initialModel : User
initialModel =
  { name = ""
  , email = ""
  , password = ""
  , loggedIn = False
  }

view : User -> Html msg
view user =
    div []
        [ h1 [] [ text "Sign up" ]
        , Html.form []
            [ div []
                [ text "Name"
                , input [ id "name", type_ "text" ] []
                ]
            , div []
                [ text "Email"
                , input [ id "email", type_ "email" ] []
                ]
            , div []
                [ text "Password"
                , input [ id "password", type_ "password" ] []
                ]
            , div []
                [ button [ type_ "submit" ]
                    [ text "Create my account" ]
                ]
            ]
        ]


main : Html msg
main =
 view initialModel