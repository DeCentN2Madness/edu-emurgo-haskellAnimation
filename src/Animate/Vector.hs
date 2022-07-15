module Animate.Vector where
  
data Vector = Vector {getX :: Int, getY :: Int}
  deriving (Show, Eq)

addVector :: Vector -> Vector -> Vector
addVector Vector {getX = x1, getY = y1} Vector {getX = x2, getY = y2} =
  Vector {getX = x1 + x2, getY = y1 + y2}

(+->) :: Vector -> Vector -> Vector
(+->) = addVector
