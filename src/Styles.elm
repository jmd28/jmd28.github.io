module Styles exposing (..)

import Utils exposing (loadStylesheet)
import Html exposing (Html)

stylesheet : Html msg
stylesheet = loadStylesheet "src/assets/global.css"

