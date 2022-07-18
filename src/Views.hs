{-# LANGUAGE OverloadedStrings #-}

module Views where

import Control.Monad.IO.Class (liftIO)
import Data.Maybe (fromJust)
import Database
import Database.PostgreSQL.Simple (Connection)
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes hiding (form, label, title)
import qualified Text.Blaze.Html5.Attributes as A
import Web.Scotty (ActionM)
import Prelude hiding (div, head)
import Prelude as P

indexView :: Connection -> ActionM Html
indexView conn = do
  postsHtml <- getPosts conn
  return $
    docTypeHtml $ do
      H.head $ do
        link ! rel "stylesheet" ! href "https://cdn.jsdelivr.net/npm/bootswatch@4.5.2/dist/darkly/bootstrap.min.css"
        link ! rel "stylesheet" ! type_ "text/css" ! href "css/styles.css"
        link ! rel "icon" ! href "img/favicon.ico" ! type_ "image/x-icon"
        title "Dev Sapiens"
      body $ do
        header $ do
          nav $ do
            a ! class_ "nav-link" ! href "/" $ "Dev Sapiens"
            a $ do img ! src "img/default_avatar.png" ! width "50" ! height "50"
        main $ do
          img ! src "img/devsapiens.svg" ! class_ "devsapiens"
          h1 "Welcome to the blog  Dev Sapiens"
          p "The blog for the new developers of the future."
          postsHtml

getPosts :: Connection -> ActionM Html
getPosts conn = do
  postData <- liftIO $ getPostData conn
  creators <- liftIO $ mapM (fmap fromJust . getCreatorById conn . postIdCreator) postData

  return $ H.div ! class_ "post" $ do mapM_ (uncurry postToHtml) $ zip postData creators
  where
    postToHtml (Post id title content idCreator createdAt updatedAt) creator = section $ do
      h2 $ toHtml title
      H.div ! class_ "author" $ do
        img ! src "img/default_avatar.png" ! width "50" ! height "50"
        h3 $ toHtml $ creatorName creator
      p ! class_ "content_post" $ toHtml content
      H.span $ toHtml $ show createdAt
