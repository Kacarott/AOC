USING: accessors arrays assocs formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals math
math.parser math.vectors namespaces pair-rocket present
sequences source-files splitting vocabs vocabs.parser ;
IN: day18

CONSTANT: DIRS {
  "R" => { 0  1 }
  "D" => { -1 0 }
  "L" => { 0 -1 }
  "U" => { 1  0 }
}

! l += d
! h += dh*d
! a += h*dx*d

: fill-area ( seq -- n )
  0 0 0 roll [
    first2 [ v*n ] [ '[ _ + ] 3dip ] bi
    first2 reach * swapd [ + ] 2bi@
  ] each nip swap 2/ 1 + + ;

: part1 ( str -- res )
  split-lines [ " " split first2 dec> [ DIRS at ] dip 2array ] map fill-area ;

: part2 ( str -- res )
  split-lines [
    " #()" split harvest last hex> 16 /mod DIRS nth last swap 2array
  ] map fill-area ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
