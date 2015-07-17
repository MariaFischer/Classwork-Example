module HW2 where

import Prelude hiding (Enum(..), sum, map)


--
-- * Part 1: Natural numbers
--

-- | Map a function over the elements in a list.
map :: (a -> b) -> [a] -> [b]
map f []     = []
map f (x:xs) = f x : map f xs

-- | The natural numbers.
data Nat = Zero
         | Succ Nat
         deriving (Eq,Show)

-- | The number 0.
zero :: Nat
zero = Zero

-- | The number 1.
one :: Nat
one = Succ zero

-- | The number 2.
two :: Nat
two = Succ one

-- | The number 3.
three :: Nat
three = Succ two

-- | The number 4.
four :: Nat
four = Succ three


-- | The predecessor of a natural number.
--
--   >>> pred zero
--   Zero
--
--   >>> pred three
--   Succ (Succ Zero)
--
pred :: Nat -> Nat
pred Zero = Zero
pred x  = (sub x one)


-- | True if the given value is zero.
--
--   >>> isZero zero
--   True
--
--   >>> isZero two
--   False
--
isZero :: Nat -> Bool
isZero Zero = True
isZero _ = False


-- | Convert a natural number to an integer.
--
--   >>> toInt zero
--   0
--
--   >>> toInt three
--   3
--
toInt :: Nat -> Int
toInt Zero = 0
toInt (Succ x) = 1 + toInt x



-- | Add two natural numbers.
--
--   >>> add one two
--   Succ (Succ (Succ Zero))
--
--   >>> add zero one == one
--   True
--
--   >>> add two two == four
--   True
--
--   >>> add two three == add three two
--   True
--
add :: Nat -> Nat -> Nat
add Zero x = x
add (Succ x) xs = Succ (add x xs)


-- | Subtract the second natural number from the first. Return zero
--   if the second number is bigger.
--
--   >>> sub two one
--   Succ Zero
--
--   >>> sub three one
--   Succ (Succ Zero)
--
--   >>> sub one one
--   Zero
--
--   >>> sub one three
--   Zero
--
sub :: Nat -> Nat -> Nat
sub Zero x = Zero
sub (Succ x) xs 	| ((toInt xs) > (toInt x)) == True 	= Zero
					| otherwise							= Succ (sub x xs)


-- | Is the left value greater than the right?
--
--   >>> gt one two
--   False
--
--   >>> gt two one
--   True
--
--   >>> gt two two
--   False
--
gt :: Nat -> Nat -> Bool
gt x xs = toInt x > toInt xs


-- | Multiply two natural numbers.
--
--   >>> mult two zero
--   Zero
--
--   >>> mult zero three
--   Zero
--
--   >>> toInt (mult two three)
--   6
--
--   >>> toInt (mult three three)
--   9
--
mult :: Nat -> Nat -> Nat
mult Zero x 		= Zero
mult (Succ x) xs 	= add xs (mult x xs)



-- | Compute the sum of a list of natural numbers.
--
--   >>> sum []
--   Zero
--
--   >>> sum [one,zero,two]
--   Succ (Succ (Succ Zero))
--
--   >>> toInt (sum [one,two,three])
--   6
--
sum :: [Nat] -> Nat
sum [] 		= Zero
sum (x:xs) 	= add x (sum xs)


-- | An infinite list of all of the *even* natural numbers, in order.
--
--   >>> map toInt (take 5 evens)
--   [2,4,6,8,10]
--
--   >>> toInt (sum (take 100 evens))
--   10100
--
evens :: [Nat]
evens = (Succ one) : map (add (Succ one)) evens



--
-- * Part 2: Lists
--


-- | Produce a list where sequences of repeated elements in the given list
--   are replaced by just one of the repeated element.
--
--   >>> compress [1,1,1,2,3,3,3,1,2,2,2,2]
--   [1,2,3,1,2]
--
--   >>> compress "Mississippi"
--   "Misisipi"
--
compress :: Eq a => [a] -> [a]
compress []     = []
compress (x:xs) = x : (compress $ dropWhile (== x) xs)


-- | Produce a list of differences between consecutive elements in the given
--   list of integers.
--
--   >>> diff [4,2,7,3,6,5]
--   [2,-5,4,-3,1]
--
--   >>> diff (map toInt (take 5 evens))
--   [-2,-2,-2,-2]
--
diff :: [Int] -> [Int]
diff [] = []
diff x 	= zipWith (-) (tail x) x  