USING: accessors formatting io io.directories io.encodings.utf8
io.files io.pathnames kernel literals namespaces present
source-files vocabs vocabs.parser ;
IN: dayX

: part1 ( str -- res ) drop f ;

: part2 ( str -- res ) drop f ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]