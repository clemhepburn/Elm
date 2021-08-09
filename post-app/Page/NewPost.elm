
module Page.NewPost exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Post exposing (Post, PostId, emptyPost, newPostEncoder, postDecoder)
import Route


type alias Model =
    { navKey : Nav.Key
    , post : Post
    , createError : Maybe String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , post = emptyPost
    , createError = Nothing
    }


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Create New Post" ]
        , newPostForm
        , viewError model.createError
        ]


newPostForm : Html Msg
newPostForm =
    Html.form []
        [ div []
            [ text "Name"
            , br [] []
            , input [ type_ "text", onInput StoreName ] []
            ]
        , br [] []
        , div []
            [ text "Message"
            , br [] []
            , input [ type_ "text", onInput StorePost ] []
            ]
        , br [] []
        , div []
            [ text "Associated Fruit"
            , br [] []
            , input [ type_ "text", onInput StoreFruit ] []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick CreatePost ]
                [ text "Submit" ]
            ]
        ]


type Msg
    = StoreName String
    | StorePost String
    | StoreFruit String
    | CreatePost
    | PostCreated (Result Http.Error Post)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StoreName name ->
            let
                oldPost =
                    model.post

                updateName =
                    { oldPost | name = name }
            in
            ( { model | post = updateName }, Cmd.none )

        StorePost post ->
            let
                oldPost =
                    model.post

                updatePost =
                    { oldPost | post = post }
            in
            ( { model | post = updatePost }, Cmd.none )

        StoreFruit fruit ->
            let
                oldPost =
                    model.post

                updateFruit =
                    { oldPost | fruit = fruit }
            in
            ( { model | post = updateFruit }, Cmd.none )

        CreatePost ->
            ( model, createPost model.post )

        PostCreated (Ok post) ->
            ( { model | post = post, createError = Nothing }
            , Route.pushUrl Route.Posts model.navKey
            )

        PostCreated (Err error) ->
            ( { model | createError = Just (buildErrorMessage error) }
            , Cmd.none
            )


createPost : Post -> Cmd Msg
createPost post =
    Http.post
        { url = "https://intense-sea-62412.herokuapp.com/api/v1/posts"
        , body = Http.jsonBody (newPostEncoder post)
        , expect = Http.expectJson PostCreated postDecoder
        }


viewError : Maybe String -> Html msg
viewError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Couldn't create a post at this time." ]
                , text ("Error: " ++ error)
                ]

        Nothing ->
            text ""