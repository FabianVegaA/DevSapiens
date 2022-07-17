{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Trans.Reader (ask, runReader)
import Lib (Config (..), ConfigR, getEnvironment)
import Network.Wai.Middleware.Static (addBase, staticPolicy)
import Routes (routes)
import Web.Scotty (middleware, scotty)

runServer :: ConfigR (IO ())
runServer = do
  env <- ask
  return $
    scotty (serverPort env) $ do
      middleware $ staticPolicy $ addBase "static"
      runReader routes env

main :: IO ()
main = do
  env <- getEnvironment
  runReader runServer env
