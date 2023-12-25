USING: accessors arrays assocs deques dlists formatting
generalizations grouping.extras hashtables io io.directories
io.encodings.utf8 io.files io.pathnames kernel literals make
math namespaces present random sequences sets sorting
source-files splitting vocabs vocabs.parser ;
FROM: sets => in? adjoin ;
IN: day25

: parse ( str -- map )
  split-lines [ [
    ": " split harvest unclip '[ _ 2dup swap [ 2array , ] 2bi@
  ] each ] each ] { } make
  sort [ first ] group-by [ first2 values 2array ] map >hashtable ;

SYMBOLS: seen counter ;
: seen? ( elt -- ? ) seen get in? ;
: reset-seen ( -- ) HS{ } clone seen set ;
: add-seen ( elt -- ) seen get adjoin ;
: reset-count ( -- ) H{ } clone counter set ;

: lightning-bolt ( map start end -- path )
  reset-seen [ 1array ] dip <dlist> swap '[ over last _ = ] [
    2over last swap at [ seen? ] reject dup [ add-seen ] each over rotd
    '[ _ swap suffix _ push-back ] each
    [ pop-front ] keep
  ] until drop nip ;

: count-island ( map -- n )
  reset-seen dup random first 1dlist [ dup deque-empty? ] [
    dup pop-front pick at [ seen? ] reject [ dup add-seen over push-back ] each
  ] until 2drop seen get cardinality ;

: lightning-storm ( map -- weak-links )
  reset-count 1000 swap '[
    _ dup keys [ random ] [ random ] bi
    lightning-bolt dup rest [ 2array sort counter get inc-at ] 2each
  ] times counter get >alist [ last ] inv-sort-by keys ;

: remove-links ( map seq -- )
  [ first2 2dup swap [ overd '[ _ swap remove ] change-at ] 2bi@ ] each drop ;

: part1 ( str -- res )
  parse dup count-island swap
  3 dupn lightning-storm 3 head remove-links
  count-island [ - ] keep * ;

: part2 ( str -- res ) drop f ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
