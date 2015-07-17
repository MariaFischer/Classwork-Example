module HW3 where

import Prelude hiding (Num)
import Data.List (intercalate)

-- * Exercise 1: MiniLogo
--
--
-- | The grammar:
--    cmd ::= pen mode
--         |  move (pos, pos)
--         |  def name (pars*) cmd
--         |  call name (vals*)
--         |  cmd; cmd
--
--   mode ::= down | up
--
--   pos ::= num | name
--
--   pars ::= name; pars | ε
--
--   vals ::= num; vals | ε
--


-- | 1. Define the abstract syntax as a set of Haskell data types
--
type Prog = [Cmd]

data Cmd = Pen Mode
		 | Move (Pos, Pos)
		 | Def String Pars Prog
		 | Call String Vals
		 | Exp Cmd Cmd
		 deriving(Eq, Show)

data Mode 	= Up 
			| Down
			deriving(Eq, Show)
data Pos	= I Int 
			| P String
			deriving(Eq, Show)
type Pars	= [String]
type Vals	= [Int]

			
-- | 2. Define a MiniLogo macro "vector"
--
vector :: Cmd
vector = Def "vector" ["x1", "y1", "x2", "y2"] [Pen Down, Move(P "x1", P "y1"), Move(P "x2", P "y2"), Pen Up]



-- | 3. Define a Haskell function steps :: Int -> Cmd
--
steps :: Int -> Cmd
steps 0 = Exp (Call "vector" [0, 0, 0, 0]) (Call "vector" [0, 0, 0, 0]) 
steps 1 = step 1 
steps n = Exp (step n) (steps (n-1))

step :: Int -> Cmd
step n = Exp (Call "vector" [n, n, n-1, n]) (Call "vector" [n, n, n-1, n-1]) 



-- * Exercise 2: Digital Circuit Design Language
--
--
-- | The grammar:
--    circuit ::= gates; links
--
--    gates ::= num; gateFn; gates | ε
--
--    gateFn ::= and | or | xor | not
--
--    links ::= from num . num to num . num; links | ε
--


-- | 1. Define the abstract syntax as a set of Haskell data types
--
-- type Circuit = (Gates, Links)
-- type Gates = [(Num, GateFN)]
-- type Links = [Link]	
-- type Num = Int
-- -- From Num Num To Num Num changed to below syntax because GHCI "Not in scpore: type contructor 'To'			
-- data Link = From Num Num Num Num
			 -- deriving (Eq,Show)
-- data GateFN = And 
			-- | Or 
			-- | Xor 
			-- | Not
			 -- deriving (Eq,Show)
data Circuit = C Gates Links
             deriving (Show)			 
data Gates   = G Int GateFN Gates | ENDGate
             deriving (Show)
data GateFN  = And | Or | Xor | Not
             deriving (Show)
data Links   = From Int Int Int Int Links | ENDLink
             deriving (Show)

-- | 2. Represent the half adder circuit as a Haskell data type
--
halfAdder :: Circuit
--halfAdder = ([(1, Xor),(2, And)], [From 1 1 2 1, From 1 2 2 2])
halfAdder = C (G 1 Xor (G 2 And (ENDGate))) (From 1 1 2 1 (From 1 2 2 2 (ENDLink)))  

-- | 3. Design a Haskell function ppCircuit :: Circuit -> String that
--      pretty-prints a Digital Circuit Design Language circuit
--
ppGateFN :: GateFN -> String
ppGateFN And = "and"
ppGateFN Or  = "or"
ppGateFN Xor = "xor"
ppGateFN Not = "not"

ppGates :: Gates -> String
ppGates ENDGate = ""
ppGates (G d e f) = show d ++ ":" ++ show e ++ "; \n " ++ (ppGates f)

ppLinks :: Links -> String
ppLinks ENDLink 	= ""
ppLinks (From i j k l m) = " from " ++ show i ++"."++ show j ++ " to " ++ show k ++ "." ++ show l++ "; \n " ++ (ppLinks m)

ppCircuit :: Circuit -> String
ppCircuit (C g l) = (ppGates g ++ ppLinks l)



-- * Exercise 3: Designing Abstract Syntax
--
--
-- | Provided data type definitions
--

data Expr = N Int
          | Plus Expr Expr
          | Times Expr Expr
          | Neg Expr
          deriving Show

data Op = Plus'
        | Times'
        | Neg'
        deriving Show

data Expr' = N' Int
           | Apply Op [Expr']
           deriving Show


-- | 1. Represent the expression -(3+4)*7 in the alternate abstract syntax
--
a1 = Apply Plus' [(N' 3), (N' 4)]
a2 = Apply Neg' [a1]
a  = Apply Times' [(a2), (N' 7)]

b = Times (Neg (Plus (N 3) (N 4))) (N 7)


-- | 2. What are the advantages and disadvantages of either representation?
--      (keep your answer to this one in comments)
-- The first [ -(3+4)*7 ] was easy to understand and calculate in my head with just a glance but not so easy to quickly convert to haskell. The second [ b = Times (Neg (Plus N 3) (Plus N 4)) (N 7) ] is also fairly easy to calculate due to its similarities to an AST and much easier to translate to haskell though a non-haskell user would be clueless so it is not ideal for multi language translation.

----The first [a] is hard to apply without double and triple checking the data Op and data Expr' version and the syntax is kind of stupidly over complicated. Whereas the second one [b] is much easier to read and quickly understand but this I will account to the fact that I recognise this syntax layout from our AST segment.

-- | 3. Define a Haskell function translate ::= Expr -> Expr' that translates
--      expressions given in the first data type definition into the alternate
--      data type definition.
--
translate :: Expr -> Expr'
translate (N a)       = (N' a)
translate (Plus b c)   = Apply Plus' [translate b, translate c]
translate (Times d e)  = Apply Times' [translate d, translate e]
translate (Neg f)      = Apply Neg' [translate (f)]

c = translate b