USING: accessors formatting io io.directories io.encodings.utf8
io.files io.pathnames kernel literals namespaces present
source-files vocabs vocabs.parser sequences.extras pair-rocket ;
IN: day19

EBNF: parse [=[
  number = ([0-9])+                        => [[ dec> ]]
  label = [a-z]+                           => [[ >string ]]
  next = label | "R" | "A"
  ltgt = [<>]                              => [[ CHAR: < = ]]
  flow = [xmas] ltgt number ":"~ next ","~ => [[ unclip "xmas" index prefix ]]
  flows = label "{"~ flow+ next "}\n"~     => [[ first3 suffix 2array ]]
  part = "\n{x="~ number ",m="~ number ",a="~ number ",s="~ number "}"~
  all = flows+ part+
]=]

: form-cond ( vals -- quot )
  first4 '{ [ _ over nth _ _ swap [ swap ] when > ] [ _ ] } ; inline

: part1 ( str -- res )
  parse first2 [ "in" [ dup { "R" "A" } in? not ] [
    pick at unclip-last [ [ form-cond ] map ] dip 1quotation suffix
    [ cond ] call( x y -- x y )
  ] while "A" = swap sum 0 ? ] map-sum nip ;

:: split-ranges ( rs cond -- rs )
  cond first4 :> ( ind lt? n tag )
  rs clone :> ns
  lt? [ n [0..b) ] [ n 1 + 4000 [a..b] ] if :> allow
  ind rs [ allow intersect ] change-nth
  tag rs 2array ,
  ind ns [ allow diff ] change-nth ns ;

: split-to-pieces ( rs conds def -- )
  -rot [ split-ranges ] each 2array , ;

: part2 ( str -- res )
  parse first 0 { { "in" ${ 4000 [1..b] 4 dupn } } } rot '[ [
    [ swap [ {
      "A" => [ [ length ] map product + ]
      "R" => [ drop ]
      [ _ at unclip-last split-to-pieces ]
    } case ] call( x x x -- x ) ] assoc-each
  ] f make harvest ] until-empty ;


MAIN: [
  $[ current-source-file get path>> parent-directory [
      current-vocab vocab-name "../../Inputs/2023/%s.txt" sprintf
      utf8 file-contents
    ] with-directory ]
  [ "Part 1: " write part1 present print ]
  [ "Part 2: " write part2 present print ] bi
]
