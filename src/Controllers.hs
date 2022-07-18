module Controllers where

import Database.PostgreSQL.Simple (Connection)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import Views.Index
import Web.Scotty (ActionM, html)

indexController :: Connection -> ActionM ()
indexController conn = do
  index <- indexView conn
  html . renderHtml $ index
