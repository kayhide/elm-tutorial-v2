module Msgs exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Http

import Models exposing (Player)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
