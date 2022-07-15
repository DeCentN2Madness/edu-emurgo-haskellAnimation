module Animate.Animation where

import Animate.Logic          ( nextState )
import Animate.Render         ( render )
import Animate.Types          ( AnimationState(..), Config(..) )
import Control.Concurrent     ( threadDelay )

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
