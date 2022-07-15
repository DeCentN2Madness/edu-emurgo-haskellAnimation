module Main where

import Animate.Cli       ( cli )
import Animate.Animation ( animate )

main :: IO ()
main = cli >>= animate
