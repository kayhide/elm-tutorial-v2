module Msgs exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Http

import Models exposing (Player)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | CloseNotice Int
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
    | ChangingName Player String
    | ChangePlayer Player
