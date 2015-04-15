{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections     #-}

import           Control.Applicative
import qualified Data.ByteString.Char8    as BS
import qualified Data.Text                as T

import Data.JStream.Parser
import Data.JStream.TokenParser

execIt :: Show a => [BS.ByteString] -> Parser a -> IO ()
execIt input parser = loop (tail input) $ runParser parser (head input)
  where
    loop [] (ParseNeedData _) = putStrLn "Out of data - "
    loop _ (ParseFailed err) = putStrLn $ "Failed: " ++ err
    loop _ (ParseDone bl) = putStrLn $ "Done: " ++ show bl
    loop (dta:rest) (ParseNeedData np) = loop rest $ np dta
    loop dta (ParseYield item np) = do
        putStrLn $ "Got: " ++ show item
        loop dta np

testParser = filterI (\(JNumber x) -> x >3) $ array value
-- testParser = (,) <$> array value <*> array value

main :: IO ()
main = do
  let test = ["[1,2,3,4,5,6,7]"]
  execIt test testParser
  return ()
