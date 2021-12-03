module Styles exposing (..)

import Utils exposing (loadStylesheet)
import Html exposing (Html)

stylesheet : Html msg
stylesheet = loadStylesheet "assets/global.css"

