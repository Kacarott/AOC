USING: accessors arrays assocs formatting grouping.extras io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math math.vectors namespaces pair-rocket present
sequences sequences.extras sets source-files splitting vectors
vocabs vocabs.parser ;
IN: day10

CONSTANT: UP    { -1 0 } CONSTANT: DOWN  { 1  0 }
CONSTANT: LEFT  { 0 -1 } CONSTANT: RIGHT { 0  1 }
CONSTANT: DIRS {
  CHAR: - => ${ LEFT RIGHT }
  CHAR: | => ${ UP DOWN }
  CHAR: L => ${ UP RIGHT }
  CHAR: J => ${ UP LEFT }
  CHAR: 7 => ${ DOWN LEFT }
  CHAR: F => ${ DOWN RIGHT }
}

: get-char ( current grid -- char )
  [ first2 swap ] dip ?nth ?nth ;

: next ( last current grid -- next )
  dupd get-char DIRS at swap '[ _ v+ ] map remove first ;

: find-start ( grid -- start next )
  dup [ [ CHAR: S = ] find drop ] map [ ] find 2array
  { $ RIGHT => "-J7" $ LEFT => "-LF" $ UP => "|7F" $ DOWN => "|LJ" }
  over roll '[ swap _ v+ _ get-char swap in? ] assoc-find 2drop dupd v+ ;

: chase ( str -- circuit )
  split-lines dup find-start 2dup 2array >vector [ rot ] dip
  [ '[ tuck _ next dup _ [ swap suffix! drop ] [ first = not ] 2bi ] loop
  2drop ] keep ;

: part1 ( str -- res )
  chase length 2/ ;

: part2 ( str -- res )
  0 0 rot chase [ dup rest swap [| s h a b | a b v-
    dup first 0 =
    [ last h * s + h ]
    [ first h + s swap ] if
  ] 2each drop abs ] [ length 2/ 1 - ] bi - ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
