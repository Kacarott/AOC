USING: accessors arrays assocs formatting grouping.extras
hashtables io io.directories io.encodings.utf8 io.files
io.pathnames kernel literals math math.combinatorics math.order
math.parser namespaces present ranges sequences sequences.extras
sets sorting source-files splitting vectors vocabs vocabs.parser ;
IN: day22

TUPLE: block x y z feet hands supports ;
: <block> ( x y z -- block ) V{ } V{ } V{ } [ clone ] tri@ \ block boa ;
M: block <=> [ z>> minimum ] bi@ <=> ;
: required? ( block -- ? ) hands>> [ feet>> length 1 = ] any? ;

: parse ( str -- blocks )
  split-lines [
    "~," split [ dec> ] map halves [ [a..b] ] 2map first3 <block>
  ] { } map-as sort ;

: below? ( a b -- ? )
  [ [ x>> ] bi@ ] [ [ y>> ] bi@ ] 2bi [ intersect empty? not ] 2bi@ and ;

: link ( a b -- )
  [ swap hands>> adjoin ] [ feet>> adjoin ] 2bi ;

: lower ( n block -- )
  swap 1 + '[ _ swap length over + [a..b) ] change-z drop ;

: block-floor ( -- block ) 10 [0..b] dup 0 [0..b] <block> ;

: throw-down ( blocks -- )
  block-floor 1vector swap [
    [ dupd '[ _ below? ] filter
    [ z>> maximum ] inv-sort-by [ z>> maximum ] group-by first first2 swap ]
    [ [ lower ] keep '[ _ link ] each ]
    [ over push ] tri
  ] each drop ;

: part1 ( str -- res )
  parse dup throw-down [ required? not ] count ;

: connect-support ( table block -- )
  dup feet>> dup length 1 =
  [ [ pick at ] map [ intersect ] 1reduce ] unless last
  [ supports>> push ] 2keep
  [ pick at ] keep suffix spin set-at ;

: build-dependance-tree ( blocks -- )
  sort dup first feet>> first { } 2array 1vector swap
  [ connect-support ] with each ;

MEMO: count-falling ( block -- n )
  supports>> [ [ count-falling ] map-sum ] [ length ] bi + ;

: part2 ( str -- res )
  parse [ throw-down ]
  [ sort build-dependance-tree ]
  [ [ count-falling ] map-sum ] tri ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
