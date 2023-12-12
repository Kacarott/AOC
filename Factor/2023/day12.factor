USING: accessors arrays combinators formatting grouping.extras
io io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math math.parser namespaces pair-rocket present
sequences source-files splitting vocabs vocabs.parser ;
IN: day12

DEFER: count-opts

: blank ( xs clues i -- r )
  2over dup [ length ] [ sum ] [ length ] tri* + -
  over >= [ 1 + count-opts ] [ 3drop 0 ] if ;

:: solid ( xs clues i -- r )
  clues empty? [ 0 ] [
  clues unclip :> n :> rst
  xs i tail n cut
  [ [ CHAR: . = not ] all? ]
  [ rst empty? [ [ CHAR: # = not ] all? ] [ first CHAR: # = not ] if ] bi* and
  [ xs rst i n + 1 + count-opts ] [ 0 ] if ] if ;

MEMO: count-opts ( xs clues i -- r )
  pick length over <= [ 3drop 1 ] [
  dup reach nth {
    CHAR: . => [ blank ]
    CHAR: # => [ solid ]
    CHAR: ? => [ [ blank ] [ solid ] 3bi + ]
  } case ] if ;
  
: part1 ( str -- res )
  split-lines [
    ", " split unclip swap [ dec> ] map 0 count-opts
  ] map-sum ;

: part2 ( str -- res )
  split-lines [
    ", " split unclip [ [ dec> ] map 5 swap <array> concat 5 ] dip
    <array> "?" join swap 0 count-opts
  ] map-sum ;

MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]