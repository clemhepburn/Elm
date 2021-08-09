module Page.EditPost exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Post exposing (Post, PostId, postDecoder)
import Page.ListPosts exposing (Msg)
import Http
import RemoteData exposing (WebData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Post exposing (Post, PostId, postDecoder, postEncoder)
import Route
import Error exposing (buildErrorMessage)

type alias Model =
    { navKey : Nav.Key
    , post: WebData Post
    , saveError : Maybe String
    }

init : PostId -> Nav.Key -> ( Model, Cmd Msg )
init postId navKey =
    ( initialModel navKey, fetchPost postId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , post = RemoteData.Loading
    , saveError = Nothing
    }

fetchPost : PostId -> Cmd Msg
fetchPost postId =
    Http.get
        { url = "http://localhost:7890/api/v1/posts/" ++ Post.idToString postId
        , expect =
            postDecoder
                |> Http.expectJson (RemoteData.fromResult >> PostReceived)
        }

type Msg
    = PostReceived (WebData Post)
    | UpdateName String
    | UpdateMessage String
    | UpdateFruit String
    | SavePost
    | PostSaved (Result Http.Error Post)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PostReceived post ->
            ( { model | post = post }, Cmd.none )
        UpdateName newName ->
            let
                updateName =
                    RemoteData.map
                        (\postData ->
                            { postData | name = newName }
                        )
                        model.post
            in
            ( { model | post = updateName }, Cmd.none )
        UpdateMessage newMessage ->
            let
                updateMessage =
                    RemoteData.map
                        (\postData ->
                            { postData | post = newMessage }
                        )
                        model.post
            in
            ( { model | post = updateMessage }, Cmd.none )
        UpdateFruit newFruit ->
            let
                updateFruit =
                    RemoteData.map
                        (\postData ->
                            { postData | fruit = newFruit }
                        )
                        model.post
            in
            ( { model | post = updateFruit }, Cmd.none )
        SavePost ->
            ( model, savePost model.post )
        PostSaved (Ok postData) ->
            let
                post =
                    RemoteData.succeed postData
            in
            ( { model | post = post, saveError = Nothing }
            , Route.pushUrl Route.Posts model.navKey)
        PostSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }
            , Cmd.none 
            )

savePost : WebData Post -> Cmd Msg
savePost post =
    case post of
        RemoteData.Success postData ->
            let
                postUrl =
                    "http://localhost:7890/api/v1/posts/" ++ Post.idToString postData.id
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = postUrl
                , body = Http.jsonBody (postEncoder postData)
                , expect = Http.expectJson PostSaved postDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
        _ ->
            Cmd.none



view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Edit Post" ]
        , viewPost model.post
        , viewSaveError model.saveError
        ]

viewPost : WebData Post -> Html Msg
viewPost post =
    case post of
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]
        RemoteData.Success postData ->
            editForm postData
        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


editForm : Post -> Html Msg
editForm post =
    Html.form []
        [ div []
            [ text "Name"
            , br [] []
            , input
                [ type_ "text"
                , value post.name
                , onInput UpdateName
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Message"
            , br [] []
            , input
                [ type_ "text"
                , value post.post
                , onInput UpdateMessage
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Associated Fruit"
            , br [] []
            , input
                [ type_ "text"
                , value post.fruit
                , onInput UpdateFruit
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick SavePost ]
                [ text "Submit" ]
            ]
        ]

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Could not fetch post at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]

viewSaveError : Maybe String -> Html msg
viewSaveError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h3 [] [ text "Error saving post" ]
                , text ("Error: " ++ error)
                ]
        Nothing ->
            text ""

