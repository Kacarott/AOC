USING: accessors assocs circular formatting hashtables io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math namespaces present sequences source-files
splitting vocabs vocabs.parser ;
IN: day8

: parse ( str -- ins )
  split-lines unclip swap rest [ " ()=," split harvest ] map
  flip first3 overd [ zip >hashtable ] 2bi@
  '[ CHAR: L = _ _ ? ] { } map-as <circular> ;

: chase ( map elt quot -- count )
  swapd '[ over _ call( x -- ? ) not ] 0 spin
  '[ tuck _ nth at swap 1 + ] while nip ;

: part1 ( str -- res )
  parse "AAA" [ "ZZZ" = ] chase ;

: part2 ( str -- res )
  parse dup first keys [ last CHAR: A = ] filter
  [ [ last CHAR: Z = ] chase ] with map 1 [ lcm ] reduce ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]