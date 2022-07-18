module BFCodeGen where
import Data.List
import Data.Ord
import Data.Maybe
import Data.Char

x ^-^ y = x `mod` y

compareCase :: (Integral a) => (a,a,a,a) -> a
compareCase (a,b,s,k) =
    let extras = if a+b > 0 then 6 else 0
    in a + b + (abs s) + (abs k) + extras

calc :: (Integral a) => a -> [(a,a,a,a)] -> Maybe (a,a,a,a)
calc c allCases =
    if c == 0
        then Just (0,0,0,0)
    else
        let workCases = filter (\(a,b,s,t) -> t * b `mod` 256 == c) allCases
            useCases = map (\(a,b,s,t) -> (a,b,s,0)) workCases
        in case useCases of
            [] -> Nothing
            _ -> Just (minimumBy (comparing compareCase) useCases)

slice :: Int -> Int -> [a] -> [a]
slice from to xs = take (to - from) (drop from xs)

compareMaybeCase :: (Integral a) => Maybe (a,a,a,a) -> Maybe (a,a,a,a) -> Ordering
compareMaybeCase Nothing Nothing = EQ
compareMaybeCase (Just vala) Nothing = GT
compareMaybeCase Nothing (Just valb) = LT
compareMaybeCase (Just a) (Just b) = compare (compareCase a) (compareCase b)

get_nei_range :: Int -> Int -> Int -> (Int, Int)
get_nei_range index span lencs =
    (l,r)
    where
        l = max 0 (index - span + 1)
        r = min lencs (index + span)

best_neis_pos :: (Integral a) => Int -> [Maybe (a,a,a,a)] -> [(Maybe (a,a,a,a), a)]
best_neis_pos index cs =
    zip subCs pos
    where
        span = 10
        (l,r) = get_nei_range index span $ length cs
        lshift = l - index
        rshift = r - index
        subCs = slice l r cs
        pos = slice lshift rshift $ (reverse $ take (max 0 (-lshift)) [-1,-2..]) ++ [0..]

best_neis :: (Integral a) => Int -> [Maybe (a,a,a,a)] -> Maybe (a,a,a,a)
best_neis index cs =
    minimumBy compareMaybeCase workNeis
    where
        neis = map (\(val, shift) -> case val of
            Just (a,b,s,k) -> Just (a,b,s, k - shift)
            Nothing -> Nothing) $ best_neis_pos index cs
        workNeis = filter(\nei -> case nei of
            Just _ -> True
            Nothing -> False) neis

lastN :: Int -> [a] -> [a]
lastN n xs = drop (max ((length xs) - n) 0) xs

best_left :: (Integral a) => [Maybe (a,a,a,a)] -> [Maybe (a,a,a,a)]
best_left_fn :: (Integral a) => [Maybe (a,a,a,a)] -> [Maybe (a,a,a,a)] -> [Maybe (a,a,a,a)]
best_left_fn last10 value =
    lastN 10 (last10 ++ [curr_best])
    where   values    = last10 ++ value
            curr_best = best_neis (length last10) values
best_left cs = map last (scanl1 best_left_fn $ map (\c -> [c]) cs)
best_left_test cs = scanl1 best_left_fn $ map (\c -> [c]) cs

best_right :: (Integral a) => [Maybe (a,a,a,a)] -> [Maybe (a,a,a,a)]
best_right_fn :: (Integral a) => [Maybe (a,a,a,a)] -> [Maybe (a,a,a,a)] -> [Maybe (a,a,a,a)]
best_right_fn value next10 =
    take 10 ([curr_best] ++ next10)
    where
        values    = value ++ next10
        curr_best = best_neis 0 values
best_right cs = map head (scanr1 best_right_fn $ map (\c -> [c]) cs)
best_right_test cs = scanr1 best_right_fn $ map (\c -> [c]) cs

get_code:: (Integral a) => a -> [Char]
get_code n = if n >= 0 then (take (fromIntegral n) (repeat '+')) else (take (-(fromIntegral n)) (repeat '-'))

gen_code :: (Integral a) => Char -> [(a,a,a,a)] -> [Char]
gen_code c best_c =
    let index = ord c
        (a,b,s,k) = best_c!!index
        s_code = get_code s
        loop_code = if a+b >0 then ("[" ++ (get_code (-a)) ++ ">" ++ (get_code b) ++ "<]>") else ""
        k_code = get_code k
    in s_code ++ loop_code ++ k_code ++ "."