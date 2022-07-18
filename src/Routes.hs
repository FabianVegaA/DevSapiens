{-# LANGUAGE OverloadedStrings #-}

module Routes where

import Control.Monad.Trans.Reader (ask)
import Controllers
import Database.PostgreSQL.Simple (Connection)
import Lib (Config (..), ConfigR)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import Web.Scotty (ActionM, ScottyM, get, html, middleware)

routes :: ConfigR (ScottyM ())
routes = do
  conn <- connPG <$> ask
  return $ do
    get "/" $ indexController conn
