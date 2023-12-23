USING: accessors arrays assocs formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals make
math math.vectors namespaces present sequences source-files
vocabs vocabs.parser ;
FROM: sets => in? ;
IN: day23

CONSTANT: width 142
CONSTANT: end 20019 ! hardcoded cus lazy
CONSTANT: start 1
CONSTANT: slopes {
  { CHAR: >  1 } ${ CHAR: v width }
  { CHAR: < -1 } ${ CHAR: ^ width neg } }
SYMBOL: board

: valid-steps ( pos last -- steps )
  dupd '[ first2 _ + dup _ = not -rot board get ?nth swap CHAR: . 2array in? and ]
  slopes swap filter values n+v ;

: junction? ( pos last -- ? )
  [ valid-steps length 1 > ]
  [ drop ${ start end } in? ] 2bi or ;

: next-junction ( current last -- count/f junction/f )
  [ 1 -rot [ [ 2dup junction? ] [ f t ] if* ] [ [ 1 + ] 2dip dupd
  valid-steps [ drop f f ] [ first ] if-empty swap ] until drop ] keep
  over = [ 2drop f f ] when ;

: link-junctions ( junction -- )
  dup building get key? [ drop ] [ [
    V{ } clone 2dup swap ,,
    '[ _ next-junction [ dup link-junctions swap 2array _ push ] [ drop ] if* ]
  ] keep f valid-steps swap each ] if ;

: max-path ( junctions seen current -- max )
  2dup f 2array over push [ dup end = [ 3drop 0 ] [
    pick at over assoc-diff [ first2 [ max-path ] dip + ] 2with map
    [ -1/0. ] [ maximum ] if-empty
  ] if ] dip pop* ;

: part1 ( str -- res )
  board set [ start link-junctions ] H{ } make V{ } clone start max-path ;

: part2 ( str -- res )
  { ">." "<." "^." "v." } substitute part1 ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
