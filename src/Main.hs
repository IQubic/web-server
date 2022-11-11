{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import Servant
import Network.Wai.Handler.Warp (run)
import Control.Monad.IO.Class

import Data.Time

import Text.Read (readMaybe)
import Data.Maybe (fromMaybe)

type API = "time" :> QueryParam "tz" String :> Get '[PlainText] String

-- Attempt to convert QueryParam into a TimeZone
-- Use UTC as a fallback if QueryParam is missing, or parse fails
-- Then get current UTC time and convert to LocalTime
server :: Server API
server s = liftIO (show . utcToLocalTime tz <$> getCurrentTime)
  where
    tz :: TimeZone
    tz = fromMaybe utc (s >>= readMaybe)

main :: IO ()
main = run 8080 $ serve (Proxy @API) server
