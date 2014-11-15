module Router where

import Graphics.Input as Input
import Graphics.Input.Field as Field
import Http
import JavaScript.Experimental as JS
import Json
import Window

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Html.Tags (..)
import Html.Optimize.RefEq as Ref

-- Router Logic --

type RouterState =
    { url           : String
    , routeId       : Maybe String
    , routeData     : [String]
    }

port requestURL : Signal String
port requestURL = go.signal

port routerState : Signal RouterState

{-| Full application state -}

data Action
    = NoOp
    | UpdateInput String

type State =
    { input         : String
    }

emptyState : State
emptyState =
    { input         = ""
    }

updateState : Action -> State -> State
updateState action state =
    case action of
        NoOp -> state
        UpdateInput str -> { state | input <- str }

state : Signal State
state = foldp updateState emptyState actions.signal

{-| Full application inputs -}

actions : Input.Input Action
actions = Input.input NoOp

go : Input.Input String
go = Input.input ""

{-| Full application view -}

defaultView : State -> Html
defaultView state = div [] [ text "This is the default view." ]

postView : State -> Html
postView state = div [] [ text "Viewing a post." ]

view : RouterState -> State -> Html
view router state =
    let
        viewFunc = case router.routeId of
            Just "PostView" -> postView
            Just _ -> defaultView
            Nothing -> defaultView
    in
        div
            [ class "container" ]
            [ input [ type' "text", placeholder "Enter URL here...", on "input" getValue actions.handle UpdateInput ] []
            , button [ type' "button", on "click" getAnything go.handle (\_ -> state.input) ] [ text "Goto URL" ]
            , viewFunc state
            ]

scene : (Int, Int) -> RouterState -> State -> Element
scene (w, h) router state = toElement w h (view router state)

main : Signal Element
main = scene <~ Window.dimensions
              ~ routerState
              ~ state
