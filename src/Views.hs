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
            let avatarLink = "https://cdn-icons.flaticon.com/png/512/3177/premium/3177440.png?token=exp=1657946917~hmac=36516928182eb7ecabaf8ed23e06055c"
            a $ do img ! src avatarLink ! width "50" ! height "50"
        main $ do
          img ! src "img/devsapiens.svg" ! class_ "devsapiens"
          postsHtml

getPosts :: Connection -> ActionM Html
getPosts conn = do
  postData <- liftIO $ getPostData conn
  creators <- liftIO $ mapM (fmap fromJust . getCreatorById conn . postIdCreator) postData

  return $ H.div $ do mapM_ (uncurry postToHtml) $ zip postData creators
  where
    postToHtml (Post id title content idCreator createdAt updatedAt) creator = section ! class_ "post" $ do
      h2 $ toHtml title
      H.div ! class_ "author" $ do
        img ! src "https://robohash.org/ba1e3a7f80ff6bc4e0f438782686f5ec?set=set4&bgset=&size=400x400" ! width "50" ! height "50"
        h3 $ toHtml $ creatorName creator
      p $ toHtml content
      H.span $ toHtml $ show createdAt
