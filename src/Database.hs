{-# LANGUAGE OverloadedStrings #-}

module Database where

import Data.Time
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.Time

data Post = Post
  { postId :: Int,
    postTitle :: String,
    postContent :: String,
    postIdCreator :: Int,
    postCreatedAt :: LocalTimestamp,
    postUpdatedAt :: LocalTimestamp
  }

data Creator = Creator
  { creatorId :: Int,
    creatorName :: String,
    creatorEmail :: String,
    creatorPassword :: String
  }

data Comment = Comment
  { commentId :: String,
    commentContent :: String,
    commentIdCreator :: String,
    commentCreatedAt :: LocalTimestamp,
    commentUpdatedAt :: LocalTimestamp
  }

instance FromRow Creator where
  fromRow = Creator <$> field <*> field <*> field <*> field

instance FromRow Post where
  fromRow = Post <$> field <*> field <*> field <*> field <*> field <*> field

instance FromRow Comment where
  fromRow = Comment <$> field <*> field <*> field <*> field <*> field

getPostData :: Connection -> IO [Post]
getPostData conn = query_ conn "SELECT * FROM posts"

getCreatorById :: Connection -> Int -> IO (Maybe Creator)
getCreatorById conn id = do
  result <- query conn "SELECT * FROM creator WHERE id = ?" (Only id)
  return $ case result of
    [] -> Nothing
    xs -> Just $ head xs
