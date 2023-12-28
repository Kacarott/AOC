USING: accessors formatting io io.directories io.encodings.utf8
io.files io.pathnames kernel literals namespaces present
source-files vocabs vocabs.parser ;
IN: day15

: hash ( seq -- n ) 0 [ + 17 * 256 rem ] reduce ;
: part1 ( str -- res ) "," split [ hash ] map-sum ;

: del ( lst tag -- ) but-last dup hash rot nth delete-at ;
: ins ( lst tag -- ) "=" split first2 dec> swap dup hash roll nth set-at ;
: score ( lst -- n )
  0 swap [ 1 + swap values [ 1 + * * + ] with each-index ] each-index ;
: part2 ( str -- res )
  256 [ V{ } clone ] replicate swap "," split dupd [
    CHAR: - over in? [ del ] [ ins ] if
  ] with each score ;

MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
