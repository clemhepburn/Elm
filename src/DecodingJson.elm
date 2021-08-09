module DecodingJson exposing (main)

import Json.Decode.Pipeline exposing (required, optional)
import Browser
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, string)
import RemoteData exposing (RemoteData, WebData)
        

type alias Post =
    { id : String
    , title : String
    , authorName : String
    , authorUrl : String
    , name : String
    , post : String
    }

type alias Model =
    { posts : WebData (List Post)
    }

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchPosts ]
            [ text "Refresh Posts" ]
            , viewPostsOrError model
            ]

viewPostsOrError : Model -> Html Msg
viewPostsOrError model =
    case model.posts of
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]
        RemoteData.Success posts ->
            viewPosts posts
        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)
        
viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        ,  text ("Error: " ++ errorMessage)
        ]

viewPosts : List Post -> Html Msg
viewPosts posts =
    div []
      [ h3 [] [ text "Posts" ]
      , table []
          ([ viewTableHeader ] ++ List.map viewPost posts)
      ]

viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "Id" ]
        , th []
            [ text "Post" ]
        , th []
            [ text "Name" ]
        ]

viewPost : Post -> Html Msg
viewPost post =
    tr []
        [ td []
            [ text post.id ]
        , td []
            [ text post.post ]
        , td []
            [ a  [ href post.authorUrl ] [ text post.name ] ]
        ]

type Msg
    = FetchPosts
    | PostsReceived (WebData (List Post))


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
        |> optional "id" string "unknown"
        |> optional "title" string "unknown"
        |> optional "authorName" string "unknown"
        |> optional "authorUrl" string "unknown"
        |> optional "name" string "unknown"
        |> optional "post" string "unknown"


fetchPosts : Cmd Msg
fetchPosts =
    Http.get
        { url = "https://intense-sea-62412.herokuapp.com/api/v1/posts"
        , expect = 
            list postDecoder
               |> Http.expectJson (RemoteData.fromResult >> PostsReceived) 
        }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPosts ->
            ( { model | posts = RemoteData.Loading }, fetchPosts )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message
        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."
        Http.NetworkError ->
            "Unable to reach server."
        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode
        Http.BadBody message ->
            message

init : () -> ( Model, Cmd Msg )
init _ =
    ( { posts = RemoteData.Loading }, fetchPosts )

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

