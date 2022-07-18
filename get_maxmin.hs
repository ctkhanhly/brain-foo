import BFCodeGen
import Data.List
import Data.Maybe
import Data.Char

main = do
    let allCases = [ (a,b,s,t) |    a <- [2..50],
                                    b <- [0..50], s <- [-50..50],
                                    let l = dropWhile (\t -> (-t*a+s) `mod` 256 /= 0) [0..255],
                                    (length l) > 0,
                                    let t = head l,
                                    s /= 0]
    let cs = [calc c allCases | c <- [0..255]]
    let csWorked = filter(\c -> case c of
            Just _ -> True
            Nothing -> False) cs
    let best_c_maybe = map (\(bl, br) -> (minimumBy compareMaybeCase) [bl,br]) $ zip (best_left cs) (best_right cs)
    let mx = maximumBy compareMaybeCase best_c_maybe
    let mn = minimumBy compareMaybeCase best_c_maybe
    putStrLn $ show $ compareCase $ fromJust mx
    putStrLn $ show $ compareCase $ fromJust mn