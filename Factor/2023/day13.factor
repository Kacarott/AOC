USING: accessors arrays assocs formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals math
math.bitwise math.parser namespaces present ranges sequences
source-files splitting vocabs vocabs.parser ;
IN: day13

: left ( seq errs -- ind )
  [ { } swap dup length [1..b) ] dip '[
    drop unclip '[ _ prefix ] dip
    2dup [ bitxor bit-count ] 2map sum _ =
  ] find 0 or 3nip ;

: parse ( str -- seq<h,v> )
  { "#1" ".0" } substitute "\n\n" split-subseq
  [ "\n" split dup flip [ [ bin> ] map ] bi@ 2array ] map ;

: run ( str errs -- res )
  [ parse ] dip '[ first2 [ _ left ] bi@ [ 100 * ] dip + ] map-sum ;

: part1 ( str -- res ) 0 run ;

: part2 ( str -- res ) 1 run ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]