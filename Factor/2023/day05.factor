USING: accessors arrays combinators formatting grouping io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals make math math.order math.parser math.vectors multiline
namespaces peg.ebnf present ranges sequences sets sorting
source-files vocabs vocabs.parser ;
IN: day05

EBNF: parse [=[
  number = [0-9]+                               => [[ dec> ]]
  range = { number number number }              => [[ first3 swapd 3array ]]
  map = ( "\n\n" [-a-z]+ )~ " map:"~ { range }+ => [[ sort ]]
  seeds = ((" "?)~ number)+
  total = "seeds:"~ seeds { map }+
]=]

: in-range? ( a b l -- quot: ( n -- ? ) )
  nip over + 1 - '[ dup _ _ between? ] ;

: range-map ( a b l -- quot: ( n -- m ) )
  drop swap - '[ _ + ] ;

: part1 ( str -- res )
  parse first2
  [ [ first3 [ in-range? ] [ range-map ] 3bi 2array ] map
  [ ] suffix '[ _ cond ] ] map
  '[ _ [ call( x -- x ) ] each ] map minimum ;

: seed-ranges ( seq -- ranges )
  2 group [ first2 1 \ range boa ] map ;

M: range v+n [ [ length>> ] [ step>> ] [ from>> ] tri ] dip + -rot \ range boa ;

: left ( range mapper -- range )
  first3 2drop [ [ from>> ] [ length>> over + ] bi ] dip min 1 - 1 <range> ;

: centre ( range mapper -- range )
  first3 1 - -rot over - [ swap over + [a..b) intersect ] dip v+n ;

: right ( range mapper -- range )
  first3 swapd + nip '[ from>> _ max ] [ from>> ] [ length>> + ] tri 1 - 1 <range> ;

: map-range ( ranges map -- ranges )
  '[ [ _ [ [ right ] [ centre , ] [ left , ] 2tri ] each , ] f make harvest ]
  map concat members sort ;

: part2 ( str -- res )
  parse first2 [ seed-ranges sort ] dip [ map-range ] each [ from>> ] map minimum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
