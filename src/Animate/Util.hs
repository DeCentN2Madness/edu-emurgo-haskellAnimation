module Animate.Util where

-- Util
joinIOs :: [IO ()] -> IO ()
joinIOs = sequence_
