module Update exposing (..)

import RemoteData exposing (WebData)
import Material

import Msgs exposing (Msg(..))
import Commands exposing (savePlayerCmd)
import Models exposing (Model, Notice(..), Player)
import Routing exposing (parseLocation)


noticeRemoteDataResponse : Model -> RemoteData.RemoteData e a -> List Notice
noticeRemoteDataResponse model data =
    case data of
        RemoteData.Loading ->
            Info "Loading..." :: model.notices

        RemoteData.Failure error ->
            Alert (toString error) :: model.notices

        _ ->
            model.notices


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            let model_ =
                    { model
                        | notices = noticeRemoteDataResponse model response
                        , players = response
                    } |> initEditing
            in
                (model_,  Cmd.none)

        Msgs.OnLocationChange location ->
            let model_ =
                    { model
                        | route = parseLocation location
                    } |> initEditing
            in
                (model_,  Cmd.none)

        Msgs.CloseNotice i ->
            let newNotices =
                    model.notices
                        |> List.indexedMap (,)
                        |> List.filter (Tuple.first >> (/=) i)
                        |> List.map Tuple.second
            in
                ({ model | notices = newNotices }, Cmd.none)

        Msgs.OnPlayerSave (Ok player) ->
            let info = Info "Updated the player."
                model_ =
                    { model
                        | notices = info :: model.notices
                        , players = updatePlayer model player
                    } |> initEditing
            in
                (model_, Cmd.none)

        Msgs.OnPlayerSave (Err error) ->
            let alert = Alert "Failed to save the player."
                model_ =
                    { model | notices = alert :: model.notices }
                        |> initEditing
            in
                (model_, Cmd.none)

        Msgs.ChangeName x ->
            let f p = { p | name = x }
            in
                model |> editPlayer f

        Msgs.ChangeLevel x ->
            let f p = { p | level = p.level + x }
            in
                model |> editPlayer f

        Msgs.SavePlayer ->
            let cmd =
                    model.editing
                        |> Maybe.map (Tuple.second >> savePlayerCmd)
                        |> Maybe.withDefault Cmd.none
            in
                (model, cmd)

        Msgs.RevertPlayer ->
            (model |> initEditing, Cmd.none)

        Msgs.Mdl msg_ ->
            Material.update Mdl msg_ model


updatePlayer : Model -> Player -> WebData (List Player)
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer
            else
                currentPlayer

        updatePlayerList players =
            List.map pick players
    in
        RemoteData.map updatePlayerList model.players


initEditing : Model -> Model
initEditing model =
    case (model.route, model.players) of
        (Models.PlayerRoute id, RemoteData.Success players) ->
            let maybePlayer =
                    players
                        |> List.filter (.id >> (==) id)
                        |> List.head
            in
                case maybePlayer of
                    Just player ->
                        { model | editing = Just (player, player) }

                    _ ->
                        { model | editing = Nothing }

        _ ->
            { model | editing = Nothing }


editPlayer : (Player -> Player) -> Model -> (Model, Cmd Msg)
editPlayer f model =
    case model.editing of
        Just (player, player_) ->
            ({ model | editing = Just (player, f player_) }, Cmd.none)

        Nothing ->
            (model, Cmd.none)
