module Post exposing
    ( Post
    , PostId
    , emptyPost
    , idParser
    , idToString
    , newPostEncoder
    , postDecoder
    , postEncoder
    , postsDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)
import Http exposing (post)


type alias Post =
    { id : PostId
    , name : String
    , post : String
    , fruit : String
    }


type PostId
    = PostId Int


postsDecoder : Decoder (List Post)
postsDecoder =
    list postDecoder


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
        |> required "id" idDecoder
        |> required "name" string
        |> required "post" string
        |> required "fruit" string


idDecoder : Decoder PostId
idDecoder =
    Decode.map PostId int


idToString : PostId -> String
idToString (PostId id) =
    String.fromInt id


idParser : Parser (PostId -> a) a
idParser =
    custom "POSTID" <|
        \postId ->
            Maybe.map PostId (String.toInt postId)


postEncoder : Post -> Encode.Value
postEncoder post =
    Encode.object
        [ ( "id", encodeId post.id )
        , ( "name", Encode.string post.name )
        , ( "post", Encode.string post.post )
        , ( "fruit", Encode.string post.fruit )
        ]


newPostEncoder : Post -> Encode.Value
newPostEncoder post =
    Encode.object
        [ ( "name", Encode.string post.name )
        , ( "post", Encode.string post.post )
        , ( "fruit", Encode.string post.fruit )
        ]


encodeId : PostId -> Encode.Value
encodeId (PostId id) =
    Encode.int id


emptyPost : Post
emptyPost =
    { id = emptyPostId
    , name = ""
    , post = ""
    , fruit = ""
    }


emptyPostId : PostId
emptyPostId =
    PostId -1
