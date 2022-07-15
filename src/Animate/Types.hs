module Animate.Types where

import Animate.Vector ( Vector(..) )

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
