USING: accessors arrays formatting generalizations io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math namespaces present sequences sequences.extras sets
source-files splitting vocabs vocabs.parser ;
IN: day4

: count-wins ( str -- n )
  ":|" split reverse first2 
  [ split-words harvest ] bi@
  '[ _ in? ] count ;

: part1 ( str -- res )
  split-lines [
    count-wins [ 0 ] [ 1 - 2^ ] if-zero
  ] map-sum ;

: part2 ( str -- res ) 
  split-lines dup length 1 <array> 3 dupn rotd '[
    1 + [ count-wins ] dip tuck + _ <slice> [ + ] with map! drop
  ] 2each-index sum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]