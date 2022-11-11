{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import Servant
import Network.Wai.Handler.Warp (run)
import Control.Monad.IO.Class

import System.Directory
import Data.Time

import Text.Read (readMaybe)
import Data.Maybe (fromMaybe)

type API = "time" :> QueryParam "tz" String :> Get '[PlainText] String
      :<|> "dir" :> Get '[PlainText] FilePath

server :: Server API
server = time
    :<|> dir
  where
    -- Attempt to convert QueryParam into a TimeZone
    -- Use UTC as a fallback if QueryParam is missing, or parse fails
    -- Then get current UTC time and convert to LocalTime
    time :: Maybe String -> Handler String
    time s = let tz = fromMaybe utc (s >>= readMaybe) in
      liftIO (show . utcToLocalTime tz <$> getCurrentTime)
    -- Just return the current directory
    dir :: Handler FilePath
    dir  = liftIO getCurrentDirectory

main :: IO ()
main = run 8080 $ serve (Proxy @API) server
