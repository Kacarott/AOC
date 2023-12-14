USING: accessors assocs circular formatting generalizations io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math math.matrices namespaces present sequences
sequences.cords sequences.extras sorting source-files splitting
vocabs vocabs.parser ;
IN: day14

: tilt-right ( seq -- seq )
  [ "#" split [ sort ] map "#" join ] map ;

: score ( seq -- n )
  [ [ [ CHAR: O = ] dip 1 + 0 ? ] map-index sum ] map-sum ;

: rotate ( seq -- seq ) anti-flip reverse ;

: tumble ( seq -- seq ) 4 [ tilt-right rotate ] times ;

: tail-loop ( x quot: ( ... x -- ... y ) -- seq )
  f -rot H{ } clone 3 dupn
  '[ @ dup _ at [ spin nip ] [ _ assoc-size over _ set-at ] if* ]
  follow swap 1 + cut <circular> cord-append ; inline

: part1 ( str -- res ) split-lines rotate tilt-right score ;

: part2 ( str -- res )
  split-lines rotate [ tumble ] tail-loop 1000000000 nth-of score ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]