USING: accessors arrays assocs formatting heaps io
io.directories io.encodings.utf8 io.files io.pathnames kernel
literals math math.order math.vectors namespaces present
sequences source-files splitting tools.time vocabs vocabs.parser ;
IN: day17

SYMBOLS: board heap seen ;
: >board ( board -- ) board set ;
: board> ( -- board ) board get ;
: >heap ( heap -- ) heap set ;
: hpush ( val -- ) f swap heap get heap-push ;
: hpop ( -- val ) heap get heap-pop nip ;
: >seen ( seen -- ) seen set ;

TUPLE: state pos heatloss dir ;
: <state> ( pos heatloss dir -- state ) \ state boa ;
: >state< ( state -- pos heatloss dir ) [ pos>> ] [ heatloss>> ] [ dir>> ] tri ;
M: state <=> [ heatloss>> ] bi@ <=> ; inline

: seen? ( state -- ? )
  [ pos>> ] [ dir>> sq 2array ] [ heatloss>> ] tri over seen get at over 1 + or
  dupd < [ swap seen get set-at f ] [ 2drop t ] if ;

: step-forward ( pos hl dir -- pos hl dir )
  dup '[ _ + ] 2dip -rot over >rect board> ?nth ?nth [
    + rot 3dup <state> dup seen? [ drop ] [ hpush ] if
  ] [ rot ] if* ;

: step-forward' ( pos hl dir -- pos hl dir )
  dup '[ _ + ] 2dip -rot over >rect board> ?nth ?nth
  [ + ] when* rot ;

: turn ( state min max dir -- )
  '[ >state< _ * ] 2dip [ [ step-forward' ] times ] dip
  [ step-forward ] times 3drop ;

: find-path ( state min max -- res )
  [ dup pos>> board> last length board> length [ 1 - ] bi@ rect> = not ]
  -rot 2dup '[ [ _ _ C{ 0 1 } turn ] [ _ _ C{ 0 -1 } turn ] bi hpop ] while
  heatloss>> ;

: run ( str min max -- res )
  [ split-lines [ 48 v-n >array ] map >board H{ } clone >seen
  <min-heap> >heap 0 0 1 <state> ] 2dip 0 0 C{ 0 1 } <state> hpush find-path ;

: part1 ( str -- res ) 0 3 run ;

: part2 ( str -- res ) 3 7 run ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write [ part1 ] time present print ]
  [ "Part 2: " write [ part2 ] time present print ] bi
]
