module Animation where

import Control.Concurrent     ( threadDelay )
import Data.Functor           ( (<&>) )
import System.Environment     ( getArgs )

ballChar :: Char
ballChar = '♥'

verticalWallChar :: Char
verticalWallChar = '|'

horizontalWallChar :: Char
horizontalWallChar = '—'

cornerChar :: Char
cornerChar = '+'

-- initial animation configuration
data Config = Config
  { ballInitialVelocity :: Vector
  , ballInitialPosition :: Vector
  , frameWidth          :: Int
  , frameHeight         :: Int
  } deriving (Show)

-- animation state
data AnimationState = AnimationState
  { ballVelocity :: Vector
  , ballPosition :: Vector
  } deriving (Show)

-- vector
data Vector = Vector {getX :: Int, getY :: Int}
  deriving (Show, Eq)

addVector :: Vector -> Vector -> Vector
addVector Vector {getX = x1, getY = y1} Vector {getX = x2, getY = y2} =
  Vector {getX = x1 + x2, getY = y1 + y2}

(+->) :: Vector -> Vector -> Vector
(+->) = addVector

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

-- Animation logic
animate :: Config -> IO ()
animate config =
  helper
    AnimationState
      { ballVelocity = ballInitialVelocity config,
        ballPosition = ballInitialPosition config
      }
  where
    helper :: AnimationState -> IO ()
    helper state =
      putStr "\x1b[2J\x1b[H"
      >> render config state
      >> threadDelay 100000
      >> helper (nextState config state)

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

-- Main function
main :: IO ()
main = cli >>= animate

-- Util
joinIOs :: [IO ()] -> IO ()
joinIOs = sequence_
