module MyLib (someFunc) where

import Data.Map.Strict (Map)

-- datatype Date = Date { year :: Int, month :: Int, day :: Int }

newtype HabitsData = HabitsData {directories :: Map String Checkmarks}

newtype Checkmarks = Checkmarks {checkmarks :: Vector (Date, Bool)}

someFunc :: IO ()
someFunc = putStrLn "someFunc"
