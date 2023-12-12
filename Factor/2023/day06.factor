USING: accessors assocs formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals math
math.parser math.quadratic namespaces present sequences sets
source-files splitting vocabs vocabs.parser ;
IN: day06

: parse ( str -- pairs )
  split-lines first2 swap
  [ ": " split harvest rest [ dec> ] map ] bi@ zip ;

: part1 ( str -- res )
  parse 1 [ neg 1 quadratic [ >integer ] bi@ - * ] assoc-reduce ;

: part2 ( str -- res ) " " without part1 ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]