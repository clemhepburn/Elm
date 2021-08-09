module Page.ListPosts exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Post exposing (Post, postsDecoder)
import RemoteData exposing (WebData)

type alias Model =
  { posts : WebData (List Post)
  }

type Msg
  = FetchPosts
  | PostsReceived (WebData (List Post))

init : () -> ( Model, Cmd Msg )
init _ =
  ( { posts = RemoteData.Loading }, fetchPosts )

fetchPosts : Cmd Msg
fetchPosts =
  Http.get
    { url = "http://localhost:7890/api/v1/posts"
    , expect =
      postsDecoder
          |> Http.expectJson (RemoteData.fromResult >> PostsReceived)
    }
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPosts ->
            ( { model | posts = RemoteData.Loading }, fetchPosts )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )


-- views

view : Model -> Html Msg
view model =
  div [] 
    [ button [ onClick FetchPosts ]
        [ text "Refresh Posts" ]
    , viewPosts model.posts
     ]

viewPosts: WebData (List Post) -> Html Msg
viewPosts posts =
  case posts of
      RemoteData.NotAsked ->
          text ""
      RemoteData.Loading ->
          h3 [] [ text "Loading..." ]
      RemoteData.Success actualPosts ->
          div []
            [ h3 [] [ text "Elm Blog" ]
            , div []
                (List.map viewPost actualPosts)
            ]
      RemoteData.Failure httpError ->
          viewFetchError (buildErrorMessage httpError)

-- viewTableHeader : Html Msg
-- viewTableHeader =
--   tr []
--     [ th []
--       [ text "name" ]
--     , th []
--       [ text "post" ]
--     , th []
--       [ text "associated fruit" ] 
--       ]

viewPost : Post -> Html Msg
viewPost post =
    div [ style "display" "flex"
        , style "flex-direction" "column" ]
      [ span [ style "font-weight" "bold" ]
        [ text "Name: "]
      , span []
        [ text post.name ]
      , span [ style "font-weight" "bold" ]
        [ text "Message: "]
      , span []
        [ text post.post ] 
      , span [ style "font-weight" "bold" ]
        [ text "Associated Fruit: " ]
      , span []
        [ text post.fruit ]  
      ]

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
  let
    errorHeading =
      "Couldn't fetch posts at this time."
  in
  div []
    [ h3 [] [ text errorHeading ]
    , text ("Error: " ++ errorMessage)
    ]  

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
  case httpError of
      Http.BadUrl message ->
          message

      Http.Timeout ->
        "Server is taking too long to repsond. Please try again later."
      
      Http.NetworkError ->
        "Unable to reach server."
      
      Http.BadStatus statusCode ->
        "Request failed with status code: " ++ String.fromInt statusCode
      
      Http.BadBody message ->
        message

