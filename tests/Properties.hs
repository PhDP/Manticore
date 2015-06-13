{-# LANGUAGE OverloadedStrings #-}

import Test.QuickCheck
-- import Data.List
-- import Sphinx.Formula
-- import Sphinx.FOL

--tree = sized tree'
--tree' 0 = liftM Leaf arbitrary
--tree' n | n>0 =
--  oneof [liftM Leaf arbitrary,
--           liftM2 Branch subtree subtree]
--             where subtree = tree' (n `div` 2)

qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort lhs ++ [x] ++ qsort rhs
  where
    lhs = filter (< x) xs
    rhs = filter (>= x) xs

prop_ordered :: [Int] -> Bool
prop_ordered xs = ordered (qsort xs)
 where
   ordered [] = True
   ordered [_] = True
   ordered (x:y:_) = x <= y && ordered (y:xs)

main :: IO ()
main = quickCheck prop_ordered
