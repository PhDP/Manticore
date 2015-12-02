-- | Parsers for first-order logic and other important structures (e.g. Markov
-- logic networks).
module Faun.Parser where

import Data.Functor.Identity
import Text.Parsec
import Text.Parsec.String (Parser)
import qualified Text.Parsec.Token as Tok
--import Data.List (foldl')

langDef :: Tok.LanguageDef ()
langDef = Tok.LanguageDef {
    Tok.commentStart    = "/*"
  , Tok.commentEnd      = "*/"
  , Tok.commentLine     = "//"
  , Tok.nestedComments  = False
  , Tok.identStart      = alphaNum
  , Tok.identLetter     = alphaNum <|> oneOf "_'"
  , Tok.opStart         = oneOf ":!#$%&*+./<=>?@\\^|-~"
  , Tok.opLetter        = oneOf ":#$%&*+./<=>?@\\^|-"
  , Tok.reservedNames   = []
  , Tok.reservedOpNames = []
  , Tok.caseSensitive   = True
  }

lexer :: Tok.TokenParser ()
lexer = Tok.makeTokenParser langDef

parens :: Parser a -> Parser a
parens = Tok.parens lexer

reservedOp :: String -> Parser ()
--reserved = Tok.reserved lexer
reservedOp = Tok.reservedOp lexer

symbol :: String -> Parser String
symbol = Tok.symbol lexer

float, pfloat, nfloat :: ParsecT String () Identity Double

float = nfloat <|> pfloat

nfloat = do
  reservedOp "-"
  f <- Tok.float lexer
  return (-f)

pfloat = do
  optional $ reservedOp "+"
  Tok.float lexer

identifier :: ParsecT String () Identity String
identifier = Tok.identifier lexer

commaSep :: ParsecT String () Identity a -> ParsecT String () Identity [a]
commaSep = Tok.commaSep lexer

reservedOps :: [String] -> ParsecT String () Identity ()
reservedOps names = foldr1 (\x acc -> try x <|> acc) $ map reservedOp names

contents :: Parser a -> Parser a
contents p = do
  Tok.whiteSpace lexer
  r <- p
  eof
  return r

parserTrue, parserFalse :: Parser Bool
parserTrue  = reservedOps ["True", "TRUE", "true", "T", "⊤"] >> return True
parserFalse = reservedOps ["False", "FALSE", "false", "F", "⊥"] >> return False
