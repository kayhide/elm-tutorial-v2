module Msgs exposing (..)

import RemoteData exposing (WebData)

import Models exposing (Player)


type Msg =
    OnFetchPlayers (WebData (List Player))
