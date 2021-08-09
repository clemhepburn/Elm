module Post exposing (Post, postDecoder, postsDecoder)

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)


type alias Post =
    { id : String
    , name : String
    , post : String
    ,fruit : String
    }

postsDecoder : Decoder (List Post)
postsDecoder =
    list postDecoder


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
        |> optional "id" string "unknown"
        |> optional "name" string "unknown"
        |> optional "post" string "unknown"
        |> optional "fruit" string "unknown"
        




