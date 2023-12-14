USING: accessors formatting io io.directories io.encodings.utf8
io.files io.pathnames kernel literals math math.parser
math.vectors namespaces present sequences source-files splitting
vocabs vocabs.parser ;
IN: day09

: recurse ( seq -- res )
  [ 0 ] [ [ rest ] [ v- recurse ] [ last + ] tri ] if-empty ;

: part1 ( str -- res )
  split-lines [ " " split [ dec> ] map recurse ] map-sum ;

: part2 ( str -- res )
  split-lines [ " " split [ dec> ] map reverse recurse ] map-sum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]