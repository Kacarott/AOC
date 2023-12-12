USING: accessors assocs assocs.extras formatting io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math.order math.parser multiline namespaces peg.ebnf
present sequences sequences.extras source-files vocabs
vocabs.parser ;
IN: day02

EBNF: parse [=[
  number = ([0-9])+ => [[ dec> ]]
  colour = number " "~ ( "red" | "blue" | "green" ) => [[ reverse ]]
  handful = { colour (","?)~ }+
  handfuls = { handful (";"?)~ }+ => [[ [ [ max ] assoc-merge ] 1reduce ]]
  game = "Game "~ number ":"~ handfuls
  games = { game }+
]=]

: part1 ( str -- res )
  parse [
    nip V{ V{ "red" 12 } V{ "green" 13 } V{ "blue" 14 } } histogram-diff empty?
  ] assoc-filter keys sum ;

: part2 ( str -- res ) 
  parse values [ values product ] map-sum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]