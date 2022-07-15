module Animate.Cli where

import Animate.Types          ( Config(..) )
import Animate.Vector         ( Vector(..) )
import Data.Functor           ( (<&>) )
import System.Environment     ( getArgs )

-- CLI
cli :: IO Config
cli = getArgs <&> parseConfig
  where
    parseConfig :: [String] -> Config
    parseConfig [w, h, posX, posY, velX, velY] =
      Config
        { frameWidth = read w,
          frameHeight = read h,
          ballInitialPosition = Vector {getX = read posX, getY = read posY},
          ballInitialVelocity = Vector {getX = read velX, getY = read velY}
        }
    parseConfig _ = error "The expected format is width height posX posY velX and velY"
