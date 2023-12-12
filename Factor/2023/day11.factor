USING: accessors formatting io io.directories io.encodings.utf8
io.files io.pathnames kernel literals namespaces present
source-files vocabs vocabs.parser math.combinatorics ;
IN: day11

: empties ( mat -- seq )
  <enumerated> [ last members length 1 = ] filter keys ;

: star-combs ( mat -- seq )
  [ [ '[
    swap CHAR: # = [ _ 2array , ] [ drop ] if
  ] each-index ] each-index ] { } make 2 <combinations> ;

: run ( str mult -- res )
  [ split-lines [ star-combs ] [ flip empties ] [ empties ] tri ] dip
  '[ flip _ _ 2array [
    [ first2 [a..b) ] dip over '[ _ in? ] count _ 1 - * swap length + ]
    2map sum ] map-sum ;

: part1 ( str -- res ) 2 run ;
: part2 ( str -- res ) 1_000_000 run ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]