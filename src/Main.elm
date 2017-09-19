module Main exposing (..)

import Navigation exposing (Location)

import Material
import Material.Layout as Layout

import Msgs exposing (Msg)
import Models exposing (Model, initialModel)
import Routing
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchPlayers)



init : Location -> (Model, Cmd Msg)
init location =
    let currentRoute = Routing.parseLocation location
        model = initialModel currentRoute
        commands = Cmd.batch
            [ fetchPlayers
            , Layout.sub0 Msgs.Mdl
            ]
    in
        (model, commands)


subscriptions : Model -> Sub Msg
subscriptions = .mdl >> Layout.subs Msgs.Mdl


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
