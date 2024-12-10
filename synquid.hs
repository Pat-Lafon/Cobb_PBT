-- List Data Type
data List a =
    Nil :: List a
    Const :: x:a -> xs:List a -> List a

-- List length method predicate/measure
termination measure len :: List a -> {Int | _v >= 0} where
    Nil -> 0
    Cons x xs -> 1 + len xs

-- Components
zero :: {Int | _v == 0}
int_gen :: Unit -> Int
dec :: x : Int -> {Int | _v == x - 1}
leq :: x : Int -> y : Int -> {Bool | _v == x <= y}

-- Synthesis Task
sized_list_gen :: n : Int -> {List Int | len _v <= n}
sized_list_gen = ??

sized_list_gen = \n . Nil