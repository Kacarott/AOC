USING: accessors formatting io io.directories io.encodings.utf8
io.files io.pathnames kernel literals namespaces present
source-files vocabs vocabs.parser dlists ;
IN: day20

TUPLE: node tag links state ;
TUPLE: flip-flop < node ;
TUPLE: conjunction < node deps ;
PREDICATE: flip-flop-tag < string first CHAR: % = ;
PREDICATE: conjunction-tag < string first CHAR: & = ;

GENERIC: <node> ( tag -- node )
M: flip-flop-tag <node> V{ } clone f \ flip-flop boa ;
M: conjunction-tag <node> V{ } clone f over clone \ conjunction boa ;
M: string <node> V{ } clone f \ node boa ;

: set-state ( queue node state -- queue )
   2dup swap state<<
   '[ _ 2array ] [ links>> ] dip map over push-all-back ; 

GENERIC: high ( queue node -- queue )
M: flip-flop high drop ;
M: conjunction high dup deps>> [ state>> ] all? not set-state ;
M: node high t set-state ;
M: f high drop ;

GENERIC: low ( queue node -- queue )
M: flip-flop low dup state>> not set-state ;
M: conjunction low t set-state ;
M: node low f set-state ;
M: f low drop ;

: connect-nodes ( tagmap tag deps -- )
  [ "%&" without over at swap ] dip swap
  '[ _ at dup conjunction? [ [ dupd deps>> push ] keep ] when ] map
  swap links<< ;

: build-network ( str -- broadcast )
  split-lines [ " ->," split harvest unclip swap 2array ] map
  [ [ first [ "%&" without ] [ <node> ] bi 2array ] map ]
  [ [ dupd first2 connect-nodes ] each ] bi "broadcaster" swap at ;

: part1 ( str -- res )
  build-network f 2array 0 0 1000 roll '[
    _ 1dlist
    [ dup deque-empty? ] [ dup pop-front first2 [ [ 1 + ] 3dip high ] [ [ 1 + ] 2dip low ] if ] until
    drop
  ] times * ;

: part2 ( str -- res ) drop f ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]