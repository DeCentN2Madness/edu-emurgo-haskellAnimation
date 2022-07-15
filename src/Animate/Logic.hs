module Animate.Logic where

import Animate.Types    ( Config(..), AnimationState(..) )
import Animate.Vector   ( Vector(..) )

-- animation logic
-- TODO: Fix glitch when bounce.
nextState :: Config -> AnimationState -> AnimationState
nextState Config {frameHeight = height, frameWidth = width} AnimationState {ballVelocity = v, ballPosition = pos} =
  AnimationState {ballVelocity = Vector {getX = velX, getY = velY}, ballPosition = Vector {getX = posX, getY = posY}}
  where
    (posX, velX) = nextInSingleDimension width (getX pos) (getX v)
    (posY, velY) = nextInSingleDimension height (getY pos) (getY v)
    nextInSingleDimension :: Int -> Int -> Int -> (Int, Int)
    nextInSingleDimension length pos velocity = (finalPos, finalVelocity)
      where posNoWalls = pos + velocity
            bouncedRight = posNoWalls >= length
            bouncedLeft = posNoWalls <= -1
            finalVelocity = if bouncedRight || bouncedLeft then -1 * velocity else velocity
            finalPos
              | bouncedRight = 2 * length - posNoWalls - 1
              | bouncedLeft = (-1) - posNoWalls
              | otherwise = posNoWalls
