USING: accessors assocs formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals math
math.parser math.statistics namespaces present sequences sorting
source-files splitting vocabs vocabs.parser ;
IN: day7

: key ( hand -- key )
  dup [ 49 = ] partition histogram values inv-sort
  0 suffix unclip rot length + prefix prepend ;

: score ( seq -- n )
  [ 1 + swap second dec> * ] map-index sum ;

: run ( str map -- seq )
  substitute split-lines [ split-words ] map
  [ first key ] sort-by score ;

: part1 ( str -- res ) { "T:" "J;" "Q<" "K=" } run ;

: part2 ( str -- res ) { "T:" "J1" "Q<" "K=" } run ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]