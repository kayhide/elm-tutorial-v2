module Msgs exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Http
import Material

import Models exposing (Player)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | CloseNotice Int
    | OnPlayerSave (Result Http.Error Player)
    | ChangeName String
    | ChangeLevel Int
    | SavePlayer
    | RevertPlayer

    | Mdl (Material.Msg Msg)
