USING: accessors assocs combinators formatting io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals math
namespaces pair-rocket present sequences sets source-files
splitting vocabs vocabs.parser ;
IN: day16

CONSTANT: UP   C{ 0 -1 } CONSTANT: LEFT  -1
CONSTANT: DOWN C{ 0  1 } CONSTANT: RIGHT  1

: seen? ( seen pos dir -- ? )
  3dup spin at in? [ 3drop t ] [
    swapd '[ V{ } clone or _ over push ] change-at f
  ] if ;

:: walk ( grid seen pos dir -- )
  pos >rect grid ?nth ?nth [
  seen pos dir seen? [ drop ] [ {
    CHAR: . => [ grid seen pos dir + dir walk ]
    CHAR: / => [ grid seen pos dir dir sq UP * * [ + ] keep walk ]
    CHAR: \ => [ grid seen pos dir dir sq DOWN * * [ + ] keep walk ]
    CHAR: | => [ dir ${ UP DOWN } in?
      [ grid seen pos dir + dir walk ] [
      grid seen pos dir UP * [ + ] keep walk
      grid seen pos dir DOWN * [ + ] keep walk ] if ]
    CHAR: - => [ dir ${ LEFT RIGHT } in?
      [ grid seen pos dir + dir walk ] [
      grid seen pos dir UP * [ + ] keep walk
      grid seen pos dir DOWN * [ + ] keep walk ] if ]
  } case ] if ] when* ;

: run ( grid pos dir -- res )
  [ H{ } clone tuck ] 2dip walk keys length ;

: part1 ( str -- res )
  split-lines 0 RIGHT run ;

:: part2 ( str -- res )
  str split-lines :> grid grid dup first [ length 1 - ] bi@ :> ( h w ) [
  h [0..b] [| y | y 0 rect> DOWN 2array , y w rect> UP 2array , ] each
  w [0..b] [| y | 0 y rect> RIGHT 2array , h y rect> LEFT 2array , ] each
  ] f make [ grid swap first2 run ] map maximum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
