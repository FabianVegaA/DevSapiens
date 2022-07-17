module Lib
  ( Config (..),
    getEnvironment,
    ConfigR,
  )
where

import Control.Monad.Trans.Reader (Reader)
import Database.PostgreSQL.Simple
  ( ConnectInfo (..),
    Connection,
    connect,
    defaultConnectInfo,
  )
import LoadEnv (loadEnv)
import System.Environment (getEnv)

type ConfigR a = Reader Config a

data Config = Environment
  { connPG :: Connection,
    serverPort :: Int
  }

getEnvironment :: IO Config
getEnvironment = do
  loadEnv

  [host, user, password, database, port] <-
    mapM getEnv ["POSTGRES_HOST", "POSTGRES_USER", "POSTGRES_PASSWORD", "POSTGRES_DB", "PORT"]

  conn <-
    connect $
      defaultConnectInfo
        { connectHost = host,
          connectUser = user,
          connectPassword = password,
          connectDatabase = database
        }
  return $ Environment conn $ read port
