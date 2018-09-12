import strutils, sequtils

type

    AtomType = enum
      Number, Symbol

    Atom = ref object of RootObj
        children : seq[Atom]
        value : string
        AtomType : AtomType


proc `$` (a : Atom) : string =
  var list_out = "Value" & string(a.value) & "\nChildren: "
  for child in a.children:
    list_out = string(child.value)

  return list_out

proc tokenize(raw_text : string) : seq[string] =
  var copy_text = raw_text

  result = copy_text.replace("(", " ( ").replace(")", " ) ").splitWhitespace()


proc parse_from_tokens(tokens : var seq[string]) : Atom =
  if len(tokens) == 0:
    echo "Error: Unexpected EOF!"
    quit()

  let first_token = tokens[0]
  tokens.delete(0)
  echo tokens
  if first_token == "(":
    var root = Atom(value : "", children : @[])

    while tokens[0] != ")":
      root.children.add(parse_from_tokens(tokens))
    
    tokens.delete(0)
    return root

  elif first_token == ")":
    echo "Error: Unexpected ')'"
  else:
     return Atom(value : first_token)

proc parse(raw_text : string) : Atom =
  var tokens = tokenize(raw_text)

  return parse_from_tokens(tokens)

proc printTree (a : Atom) = 
  echo a.value
  for child in a.children:
    printTree(child)

var atom = parse("(+ 1 (* 3 4))")
printTree(atom)
echo "Value: ",atom.value
echo "Children: "


#echo repr(parse(""))
