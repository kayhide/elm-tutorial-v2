module Main exposing (..)

import Navigation exposing (Location)

import Msgs exposing (Msg)
import Models exposing (Model, initialModel)
import Routing
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchPlayers)



init : Location -> (Model, Cmd Msg)
init location =
    let currentRoute =
            Routing.parseLocation location
    in
        (initialModel currentRoute, fetchPlayers)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
