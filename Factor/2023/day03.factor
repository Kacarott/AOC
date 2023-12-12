USING: accessors arrays ascii assocs formatting grouping
grouping.extras io io.directories io.encodings.utf8 io.files
io.pathnames kernel literals math math.parser namespaces present
sequences sequences.extras sets sorting source-files splitting
strings vocabs vocabs.parser ;
IN: day03

: pad-grid ( grid -- grid )
  [ ".." 1surround ] map
  dup first length 46 <repetition> 1array 1surround ;

: clumpify ( grid -- clumped )
  [ 3 clump ] map 3 clump [ flip ] map concat ;

: clump>number ( clump -- n ) [ second second ] map dec> ;

: number:symbols ( str -- assoc )
  split-lines pad-grid clumpify
  [ second second digit? ] group-by <odds>
  [ second [ clump>number ] [ concat concat ] bi 2array ] map ;

: part1 ( str -- res )
  number:symbols [ second ".0123456789" diff empty? not ] filter
  [ first ] map-sum ;

: part2 ( str -- res )
  150 swap [ dup 42 = [ [ 1 + dup ] dip + ] when ] map nip number:symbols
  [ first2 [ 150 < ] reject members >string swap 2array ] map
  [ first empty? ] reject sort [ first ] group-by [ second ] map
  [ length 2 = ] filter [ values product ] map-sum ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]