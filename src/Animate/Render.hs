module Animate.Render (render) where

import Animate.Types  ( AnimationState(..), Config(..) )
import Animate.Util   ( joinIOs )
import Animate.Vector ( Vector(getX, getY) )

ballChar :: Char
ballChar = '♥'

verticalWallChar :: Char
verticalWallChar = '|'

horizontalWallChar :: Char
horizontalWallChar = '—'

cornerChar :: Char
cornerChar = '+'

-- Render logic
render :: Config -> AnimationState -> IO ()
render Config {frameWidth = width, frameHeight = height} AnimationState {ballPosition = pos} =
  joinIOs $ map renderRow $ reverse [-1 .. height]
  where
    renderRow :: Int -> IO ()
    renderRow row = putStrLn $ map (`charAt` row) [(-1) .. width]
    charAt :: Int -> Int -> Char
    charAt x y
      | x == getX pos && y == getY pos = ballChar
      | elem (x, y) [(-1, height), (width, -1), (-1, -1), (width, height)] = cornerChar
      | y == -1 || y == height = horizontalWallChar
      | x == -1 || x == width = verticalWallChar
      | otherwise = ' '
