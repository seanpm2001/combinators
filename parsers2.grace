print "Getting Parsers"



// type Object = { }



class exports { 



//   method currentIndentation {outer.currentIndetation}
//   method currentIndentation:= (x) {outer.currentIndetation:= x}
//   type InputStream = outer.InputStream
//   class stringInputStream(string : String, position' : Number) {
//         inherits outer.stringInputStream(string, position) }
//   type ParseSuccessType = outer.ParseSuccessType
//   type ParseFailureType = outer.ParseFailureType
//   type ParseResult = (outer.ParseFailureType)
//   class parseSuccess(next', result') {
//      inherits outer.parseSuccess(next', result') }
//   class parseFailure(message') { inherits parseFailure(message') }
//   class abstractParser { inherits abstractParser  }
//   type Parser = (outer.Parser)
//   class tokenParser(tken) { inherits tokenParser(tken) }
//   class whiteSpaceParser { inherits whiteSpaceParser }
//   class characterSetParser(charSet) { inherits characterSetParser(charSet) }
//   class graceIdentifierParser { inherits graceIdentifierParser }
//   class digitStringParser { inherits digitStringParser }
//   class sequentialParser(left, right) { inherits sequentialParser(left, right) }
//   class optionalParser(subParser) { inherits optionalParser(subParser) }
//   class dropParser(subParser) { inherits dropParser(subParser) }
//   class alternativeParser(left, right) { inherits alternativeParser(left, right) }
//   class bothParser(left, right) { inherits bothParser(left, right) }
//   class repetitionParser(subParser) { inherits repetitionParser(subParser) }
//   class proxyParser(proxyBlock) { inherits proxyParser(proxyBlock)  }
//   class wrappingProxyParser(proxyBlock, string) { inherits wrappingProxyParser(proxyBlock, string) }
//   class atEndParser { inherits atEndParser }
//   class notParser(subParser) { inherits notParser(subParser) }
//   class guardParser(subParser, guardBlock) { inherits guardParser(subParser, guardBlock) }
//   class successParser { inherits successParser }
//   class tagParser(tagx : String) { inherits tagParser(tagx) }
//   class phraseParser(tagx: String, subParser) { inherits phraseParser(tagx, subParser) }
//   class indentationAssertionParser(indent : Number) { inherits indentationAssertionParser(indent) }
//   class lineBreakParser(direction) { inherits lineBreakParser(direction)  }
//   method isletter(c) {outer.isletter(c)}
//   method isdigit(c) {outer.isdigit(c)}
//   method dyn(d : Unknown) (outer.dyn(d)}
//   def ws = (outer.ws)
//   method opt(p : Parser)  {outer.opt(p)
//   method rep(p : Parser)  {outer.rep(p)}
//   method rep1(p : Parser) {outer.rep1(p)}
//   method drop(p : Parser) {outer.drop(p)}
//   method trim(p : Parser) {outer.trim(p)}
//   method token(s : String)  {outer.token(s)}
//   method symbol(s : String) {outer.symbol(s)}
//   method rep1sep(p : Parser, q : Parser)  {outer.rep1sep(p,q)}
//   method repsep(p : Parser, q : Parser)  {outer.repsep(p,q)}
//   method repdel(p : Parser, q : Parser)  {outer.repdel(p,q)}
//   method rule(proxyBlock : Block)  {outer.rule(proxyBlock)}
//   method rule(proxyBlock : Block) wrap(s : String) {outer.rule(proxyBlock) wrap(s)}
//   def end = (outer.atEndParser)
//   method not(p : Parser)  {outer.not(p)}
//   method both(p : Parser, q : Parser)  {outer.both(p,q)}
//   method empty  {outer.empty} 
//   method guard(p : Parser, b : Block)  {outer.guard(p, b)} 
//   method tag(s : String) {outer.tag(s)}
//   method phrase(s : String, p : Parser) { outer.phrase(s, p) }
//   method indentAssert(i : Number) { outer.indentAssert(i) }
//   method lineBreak(direction) {outer.lineBreak(direction)}


  //SUPER-EVIL GLOBAL VARIABLE Courtesy of MR CHARLES WEIR
  var currentIndentation := 0 

  ////////////////////////////////////////////////////////////
  type InputStream = { 
   take( _ ) -> String
   rest ( _ ) -> InputStream
   atEnd -> Boolean
   indentation -> Number
  } 


  class stringInputStream(string : String, position' : Number) {
   def brand = "stringInputStrea"
   def position : Number is readable = position'

   method take(n : Number) -> String {
     var result := ""
     var endPosition := position + n - 1
     if (endPosition > string.size) then {endPosition := string.size}
     for (position .. endPosition) do { i : Number ->   
         result := result ++ string.at(i)
     }
     return result
   }

   method rest(n : Number)  {

    if ((n + position) <= (string.size + 1))
     then {return stringInputStream(string, position + n)}
     else { 
       Error.raise("FATAL ERROR END OF INPUT at {position} take {n}")
       }
   }

   method atEnd  {return position > string.size}

   method indentation {
     var cursor := position - 1
     while {(cursor > 0).andAlso {string.at(cursor) != "\n"}}
       do {cursor := cursor - 1}
     // now cursor is the char before the first in the line.
     cursor := cursor + 1
     var result := 0
     while {((cursor + result) <= string.size).andAlso {string.at(cursor + result) == " "}}
       do {result := result + 1}

     if ((cursor + result) > string.size) then {return 0} // lots of spaces then end

     return result
   }

  }

  ////////////////////////////////////////////////////////////
  // parse results

  type ParseSuccessType = {
    brand -> String
    next -> InputStream
    result -> String
    succeeded -> Boolean
    resultUnlessFailed( _ ) -> ParseResult 
  }

  type ParseFailureType = {
    brand -> String
    message -> String
    succeded -> Boolean
    resultUnlessFailed( _ ) -> ParseResult 
  }

  //type ParseResult = (ParseSuccessType | ParseFailureType)

  type ParseResult = ParseFailureType

  class parseSuccess(next', result') {
   def brand = "parseSuccess"
   def next is public  = next' 
   def result is public = result'
   method succeeded { return true }
   method resultUnlessFailed (failBlock : Block) {
     return self
   }
  }

  class parseFailure(message') {
   def brand = "parseFailure" 
   def message is public = message'
   method succeeded { return false }
   method resultUnlessFailed (failBlock : Block) { 
     return failBlock.apply(self)
   }
  }


  ////////////////////////////////////////////////////////////
  // parsers

  class abstractParser {
   def brand = "abstractParser"
   method parse(in) { }

   method ~(other) {sequentialParser(self,other)}
   method |(other) {alternativeParser(self,other)}
  }

  type Parser = { 
    parse(_ : InputStream) -> ParseResult
    ~(_ : Parser) -> Parser
    |(_ : Parser) -> Parser
  }

  // parse just a token - basically a string, matching exactly
  class tokenParser(tken) {
   inherits abstractParser
   def brand = "tokenParser"
   method parse(in) {
     def size = tken.size
     if (in.take(size) == tken) then {
        return parseSuccess(in.rest(size), "{in.take(size)}" )
       } else {
        return parseFailure(
          "expected {tken} got {in.take(size)} at {in.position}")
     }
   }
  }

  // get at least one whitespace
  class whiteSpaceParser {
   inherits abstractParser 
   def brand = "whiteSpaceParser"
   method parse(in) {
     var current := in

     while {(current.take(1) == " ") || (current.take(2) == "\\")} do {
       while {current.take(1) == " "} 
         do {current := current.rest(1)}
       if (current.take(2) == "//")
         then {
           current := current.rest(2)
           while {current.take(1) != "\n"} 
             do {current := current.rest(1)}
           current := current.take(1)
         }
     }

     if (current != in) then {
        return parseSuccess(current, " ")
       } else {
        return parseFailure(
          "expected w/s got {in.take(5)} at {in.position}")
     }
   }
  }


  // parser single character from set of acceptable characters (given as a string)
  class characterSetParser(charSet) {
   inherits abstractParser
   def brand = "characterSetParser"

   method parse(in) {
     def current = in.take(1) 

     for (charSet) do { c -> 
        if (c == current) then {
          return parseSuccess(in.rest(1), current ) }
       }

     return parseFailure(
          "expected \"{charSet}\" got {current} at {in.position}")
   }
  }

  //does *not* eat whitespace!
  class graceIdentifierParser { 
   inherits abstractParser

   def brand = "graceIdentifierParser"

   method parse(in) {
     if (in.take(1) == "_") then {
        return parseSuccess(in.rest(1), "_")                 
     }
     var current := in

     if (! isletter(in.take(1))) then {
        return parseFailure(
          "expected GraceIdentifier got {in.take(5)}... at {in.position}")
     }

     var char := current.take(1)
     var id := ""

     // print "char: <{char}>  current.atEnd <{current.atEnd}>"

     while {(!current.atEnd).andAlso {isletter(char) || isdigit(char) || (char == "'")}}
       do {
          id := id ++ char
          current := current.rest(1)
          char := current.take(1)
          // print "chlr: <{char}>  current.atEnd <{current.atEnd}>"
     }

     return parseSuccess(current, id)
   }

  }


  // dunno why this is here?
  class digitStringParser { 
   inherits abstractParser
   def brand = "digitStringParser"
   method parse(in) {

     var current := in

     var char := current.take(1)
     var id := ""

     if (char == "-") then {
       id := "-"
       current := in.rest(1)
       char := current.take(1)     
     }

     if (! (isdigit(char))) then {
        return parseFailure(
          "expected DigitString got {in.take(5)}... at {in.position}")
     }

     while {isdigit(char)}
       do {
          id := id ++ char
          current := current.rest(1)
          char := current.take(1)
     }

     return parseSuccess(current, id)
   }

  }



  class sequentialParser(left, right) { 
   inherits abstractParser
   def brand = "sequentialParser"
   method parse(in) {
      def leftResult = left.parse(in)
            .resultUnlessFailed {f -> return f}
      def rightResult = right.parse(leftResult.next)
            .resultUnlessFailed {f -> return f}
      return parseSuccess(rightResult.next, 
             leftResult.result ++ rightResult.result)
   }
  }


  class optionalParser(subParser) { 
   inherits abstractParser
   def brand = "optionalParser"
   method parse(in) {
      return (subParser.parse(in)
            .resultUnlessFailed {f -> 
                 return parseSuccess(in, "")})
  }

  }

  //match as if SubParser, discard the result
  class dropParser(subParser) {
   inherits abstractParser
   def brand = "dropParser"
   method parse(in) {
      def subRes = subParser.parse(in)
            .resultUnlessFailed {f -> return f}
      return parseSuccess(subRes.next, "")
   }

  }


  class alternativeParser(left, right) {
   inherits abstractParser
   def brand = "alternativeParser"
   method parse(in) {
      def leftResult = left.parse(in)
      if (leftResult.succeeded) then {
        return leftResult }
      return right.parse(in)
   }

  }


  //succeeds if both left & right succeed; returns LEFT parse
  //e.g. both(identifier,not(reservedIdentifiers)) -- except that's wrong!
  class bothParser(left, right) {
   inherits abstractParser
   def brand = "bothParser"
   method parse(in) {
      def leftResult = left.parse(in)
      if (!leftResult.succeeded) then {return leftResult}
      def rightResult = right.parse(in)
      if (!rightResult.succeeded) then {return rightResult}
      return leftResult
   }

  }



  class repetitionParser(subParser) {
   inherits abstractParser
   def brand = "repetitionParser"
   method parse(in) {
     var current := in

     var res := subParser.parse(in)
     var id := ""

     while {res.succeeded}
       do {
          id := id ++ res.result
          current := res.next
          res := subParser.parse(current)
     }

     return parseSuccess(current, id)
   }

  }



  class proxyParser(proxyBlock) { 
   inherits abstractParser
   def brand = "proxyParser"
   var subParser := "no parser installed"
   var needToInitialiseSubParser := true

   method parse(in) {

    if (needToInitialiseSubParser) then {
      subParser := proxyBlock.apply
      needToInitialiseSubParser := false
    }

    def previousIndentation = currentIndentation
    currentIndentation := in.indentation

    var result 

    //  if (currentIndentation < previousIndentation) then {
    //     print ("??Bad Indentation?? at {in.position}, wanted {previousIndentation} got {currentIndentation}")
    //     result := parseFailure("Bad Indentation, wanted {previousIndentation} got {currentIndentation}")
    //  } else {
    result := subParser.parse(in)
    //  }

    currentIndentation := previousIndentation

    return result
   }

  }



  class wrappingProxyParser(proxyBlock, string) {
   inherits abstractParser
   def brand = "wrappingProxyParser"
   var subParser := "no parser installed"
   var needToInitialiseSubParser := true

   method parse(in) {

    if (needToInitialiseSubParser) then {
      subParser := proxyBlock.apply
      needToInitialiseSubParser := false
    }

    def result = subParser.parse(in)
    if (!result.succeeded) then {return result}

    return parseSuccess(result.next, "[{string}{result.result}]")
   }

  }



  // get at least one whitespace
  class atEndParser { 
   inherits abstractParser
   def brand = "atEndParser"
   method parse(in) {
     if (in.atEnd) then {
        return parseSuccess(in, "")
       } else {
        return parseFailure(
          "expected end got {in.take(5)} at {in.position}")
     }
   }

  }

  // succeeds when subparser fails; never consumes input if succeeds
  class notParser(subParser) {
   inherits abstractParser
   def brand = "notParser"
   method parse(in) {
      def result = subParser.parse(in)

      if (result.succeeded)
        then {return parseFailure("Not Parser - subParser succeeded so I failed")}
        else {return parseSuccess(in,"")}
   }

  }


  class guardParser(subParser, guardBlock) {
   inherits abstractParser
   def brand = "guardParser"
   method parse(in) {
      def result = subParser.parse(in)

      if (!result.succeeded) then {return result}
      if (guardBlock.apply(result.result)) then {return result}
      return  parseFailure("Guard failure at {in.position}")
   }

  }


  class successParser {
   inherits abstractParser
   def brand = "successParser"
   method parse(in) {return parseSuccess(in,"!!success!!")}

  }


  // puts tag into output
  class tagParser(tagx : String) {
   inherits abstractParser
   def brand = "tagParser"
   method parse(in) {return parseSuccess(in, tagx)}

  }

  // puts tagx around start and end of parse
  class phraseParser(tagx: String, subParser) {
   inherits abstractParser
   def brand = "phraseParser"
   method parse(in) {
      def result = subParser.parse(in)

      if (!result.succeeded) then {return result}

      return parseSuccess(result.next,
                "<" ++ tagx ++ " " ++ result.result ++ " " ++ tagx ++ ">" )
   }

  }


  class indentationAssertionParser(indent : Number) {
   inherits abstractParser
   def brand = "indentationAssertionParser"
   method parse(in) {
     if (in.indentation == indent) 
      then {return parseSuccess(in,"")}
      else { print  "***Asserted indent=={indent}, actual indentation=={in.indentation}"
             return parseFailure "Asserted indent=={indent}, actual indentation=={in.indentation}"}
   }
  }


  class lineBreakParser(direction) { 
   inherits abstractParser
   def brand = "lineBreakParser"
   method parse(in) {

    if (in.take(1) != "\n") 
      then {return parseFailure "looking for a LineBreak-{direction}, got \"{in.take(1)}\" at {in.position}"}

    def rest = in.rest(1) 

    def actualDirection = 
      if (rest.atEnd) then { "left" }
        elseif {rest.indentation <  currentIndentation} then { "left" }
        elseif {rest.indentation == currentIndentation} then { "same" }
        elseif {rest.indentation >  currentIndentation} then { "right" }
        else {Error.raise "Tricotomy failure"}


    match (actualDirection) 
       case { _ : direction -> return parseSuccess(in.rest(1), "<<{direction}>>\n" ) }
       case { _ -> return parseFailure "looking for a LineBreak-{direction}, got {actualDirection} at {in.position}"
       }

    Error.raise "Shouldn't happen"
   }
  }





  ////////////////////////////////////////////////////////////
  // combinator functions - many of these should be methods
  // on parser but I got sick of copying everything!

  def ws = rep1((whiteSpaceParser) | lineBreak("right"))
  method opt(p : Parser)  {optionalParser(p)}
  method rep(p : Parser)  {repetitionParser(p)}
  method rep1(p : Parser) {p ~ repetitionParser(p)}
  method drop(p : Parser) {dropParser(p)}
  method trim(p : Parser) {drop(opt(ws)) ~ p ~ drop(opt(ws))}
  method token(s : String)  {tokenParser(s)}
  //method symbol(s : String) {trim(token(s))}
  method symbol(s : String) {token(s) ~ drop(opt(ws))} // changed to token with following space?
  method rep1sep(p : Parser, q : Parser)  {p ~ rep(q ~ p)}
  method repsep(p : Parser, q : Parser)  {opt( rep1sep(p,q))}
  method repdel(p : Parser, q : Parser)  {repsep(p,q) ~ opt(q)}
  method rule(proxyBlock : Block)  {proxyParser(proxyBlock)}
  //method rule(proxyBlock : Block) wrap(s : String)  {wrappingProxyParser(proxyBlock,s)}
  method rule(proxyBlock : Block) wrap(s : String)  {proxyParser(proxyBlock,s)}

  def end = atEndParser
  method not(p : Parser)  {notParser(p)}
  method both(p : Parser, q : Parser)  {bothParser(p,q)}
  method empty  {successParser} 
  method guard(p : Parser, b : Block)  {guardParser(p, b)} 
  method tag(s : String) {tagParser(s)}
  method phrase(s : String, p : Parser) { phraseParser(s, p) }
  method indentAssert(i : Number) {indentationAssertionParser(i) }

  method lineBreak(direction) {lineBreakParser(direction)}

  method parse (s : String) with (p : Parser)  {
   p.parse(stringInputStream(s,1)).succeeded
  }


  ////////////////////////////////////////////////////////////
  // "support library methods" 

  method assert  (assertion : Block) complaint (name : String) {
   if (!assertion.apply) 
     then {print "ASSERTION FAILURE"}
  }


  method isletter(c) -> Boolean {
    // print "callxd isletter({c})"
    if (c.size == 0) then {return false} //is bad. is a hack. works.
    if (c.size != 1) then {print "isletter string {c} too long"}
    //  assert {c.size == 1} complaint "isletter string too long" 
    return (((c >= "A") && (c <= "Z")) 
           || ((c >= "a") && (c <= "z")))
  }

  method isdigit(c) -> Boolean {
    // print "callxd isdigit({c})"
    //  assert {c.size == 1} complaint "isdigit string too long" 
    if (c.size == 0) then {return false} //is bad. is a hack. works. 
    return ((c >= "0") && (c <= "9")) 
  }

  print "Got Parsers"

} // end exports! 


print "done"
