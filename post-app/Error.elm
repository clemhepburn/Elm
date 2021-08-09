module Error exposing (buildErrorMessage)

import Http


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach the server."

        Http.BadStatus statusCode ->
            "Request failed with this status code: " ++ String.fromInt statusCode ++ ". Strange..."

        Http.BadBody message ->
            message