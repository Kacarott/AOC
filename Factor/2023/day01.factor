USING: accessors arrays ascii formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals math
math.parser math.text.english namespaces present ranges regexp
sequences source-files splitting strings vocabs vocabs.parser ;
IN: day01

: part1 ( str -- res )
  split-lines [
    [ digit? ] filter [ first ] [ last ] bi 2array dec>
  ] map sum ;

CONSTANT: numbers R/ one|two|three|four|five|six|seven|eight|nine|\d/
CONSTANT: srebmun R/ \d|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno/

: part2 ( str -- res )
  split-lines [
    [ reverse srebmun first-match reverse ] [  numbers first-match ] bi
    [ [ dec> ] [ >string 9 [0..b] [ number>text ] map index ] bi xor ] bi@ 10 * +
  ] map sum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]