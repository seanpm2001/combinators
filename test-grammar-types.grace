dialect "parserTestDialect"
import "parsers2" as parsers
inherits parsers.exports 
import "grammar" as grammar
inherits grammar.exports


test (typeId) on "type" correctly "16aa1"
test (typeId ~ end) on "type" correctly "16aa2"

test (typeExpression) on "  " correctly "008type1"
test (typeExpression ~ end) on "   " correctly "008type1"
test (typeExpression ~ end) on "Integer" correctly "008type2"
test (typeExpression ~ end) on "  Integer  " correctly "008type3"


test (typeLiteral) on "type \{ \}" correctly "016cl"
test (typeLiteral) on "type \{ foo \}" correctly "016cl1"
test (typeLiteral) on "type \{ foo; bar; baz; \}" correctly "016cl2"
test (typeLiteral) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016cl3"

test (typeExpression ~ end) on "type \{ \}" correctly "016cx1"
test (typeExpression ~ end) on "type \{ foo \}" correctly "016cx2"
test (typeExpression ~ end) on "type \{ foo; bar; baz; \}" correctly "016cx3"
test (typeExpression ~ end) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016cx4"
test (typeExpression ~ end) on "\{ \}" correctly "016cx5"
test (typeExpression ~ end) on "\{ foo \}" correctly "016cx5"
test (typeExpression ~ end) on "\{ foo; bar; baz; \}" correctly "016cx7"
test (typeExpression ~ end) on "\{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016cx8"

test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo -> T" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "prefix!" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "+(x : T)" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo;" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo; bar;" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo; bar; baz" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo[[T]] -> T" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo[[T]]" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "prefix! [[T]]" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "+(x : T)" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo[[T]];" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo[[T]]; bar[[T]];" correctly "016d1"
test ( repsep( methodHeader ~ methodReturnType, semicolon)) on "foo; bar[[T]]; baz[[T]]" correctly "016d1"
test (typeId ~ lBrace ~ repdel( methodHeader ~ methodReturnType, semicolon) ~ rBrace) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016e"
test (repdel( methodHeader ~ methodReturnType, semicolon)) on "prefix!; +(other : SelfType); baz(a,b) baz(c,d)" correctly "016e"
test (typeExpression ~ end) on "T" correctly "016c"
test (lGeneric ~ typeExpression ~ rGeneric ~ end) on "[[T]]" correctly "016c"
test (typeExpression ~ end) on "type \{ \}" correctly "016c"
test (typeExpression ~ end) on "type \{ foo \}" correctly "016c"
test (typeExpression ~ end) on "type \{ foo; bar; baz; \}" correctly "016d"
test (typeExpression ~ end) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016e"
test (typeExpression ~ end) on "type \{ prefix!; +(other : SelfType); baz(a,b) baz(c,d); \}" correctly "016e"
test (typeExpression ~ end) on "" correctly "016a"
test (typeExpression ~ end) on "T" correctly "016a"
test (typeExpression ~ end) on "=T" wrongly "016a"
test (typeExpression ~ end) on "!T" wrongly "016a"
test (typeExpression ~ end) on "T[[A,B]]" correctly "016c"
test (typeExpression ~ end) on "T[[B]]" correctly "016c"
test (typeExpression ~ end) on "A & B" correctly "016c"
test (typeExpression ~ end) on "A & B & C" correctly "016c"
test (typeExpression ~ end) on "A & B[[X]] & C" correctly "016ct"
test (typeExpression ~ end) on "A | B[[X]] | C" correctly "016ct"
test (expression ~ end) on "A & B(X) & C" correctly "016cx"
test (expression ~ end) on "A | B(X) | C" correctly "016cx"
test (expression ~ end) on "A & B[[X]] & C" correctly "016cx"
test (expression ~ end) on "A | B[[X]] | C" correctly "016cx"
test (typeExpression ~ end) on "A & B | C" wrongly "016c"
test (typeExpression ~ end) on "A & type \{ foo(X,T) \}" correctly "016c"
test (typeExpression ~ end) on " \"red\"" correctly "016t1"
test (typeExpression ~ end) on " \"red\" | \"blue\" | \"green\"" correctly "016t1"
test (typeExpression ~ end) on " 1 | 2 | 3 " correctly "016t1"
test (expression ~ end) on "\"red\"|\"blue\"|\"green\"" correctly "016t1"
test (expression ~ end) on " \"red\" | \"blue\" | \"green\"" correctly "016t1"
test (expression ~ end) on " 1 | 2 | 3 " correctly "016t1"
test (typeExpression ~ end) on "super.T[[A,B]]" correctly "016pt"
test (typeExpression ~ end) on "super.A & x.B" correctly "016pt"
test (typeExpression ~ end) on "super.A & a.B & a.C" correctly "test"
test (typeExpression ~ end) on "super.A & B[[super.X]] & C" correctly "016ptt"
test (typeExpression ~ end) on "A | B[[X]] | C" correctly "016ptt"
test (typeExpression ~ end) on "T[[super.A.b.b.B.c.c.C,super.a.b.c.b.b.B]]" correctly "016pt"
test (typeExpression ~ end) on "a[[X,super.Y,z.Z]].a.A & b.b.B" correctly "016pt"
test (typeExpression ~ end) on "a[[X,super.Y,z.Z]].a.A & b.b.B & c.c.C" correctly "016pt"
test (typeExpression ~ end) on "a[[X,super.Y,z.Z]].a.A & b.b.B[[X]] & c.c.C" correctly "016ptt"
test (typeExpression ~ end) on "a[[X,super.Y,z.Z]].a.A | b.b.B[[X]] | c.c.C" correctly "016ptt"
test (typeDeclaration ~ end) on "type A = B;" correctly "016td1"
test (typeDeclaration ~ end) on "type A=B;" correctly "016td2"
test (typeDeclaration ~ end) on "type A[[B,C]] = B & C;" correctly "016td3"
test (typeDeclaration ~ end) on "type A[[B]] = B | Noo | Bar;" correctly "016td4"
test (typeDeclaration ~ end) on "type Colours = \"red\" | \"green\" | \"blue\";" correctly "016td5"
test (typeDeclaration ~ end) on "type FooInterface = type \{a(A); b(B); \};" correctly "016td6"
test (typeDeclaration ~ end) on "type FooInterface = \{a(A); b(B); \};" correctly "016td7"
test (typeDeclaration ~ end) on "type PathType = super.a.b.C;" correctly "016td8"
test (typeDeclaration ~ end) on "type GenericPathType[[A,X]] = a.b.C[[A,X]];" correctly "016td9"

test (whereClause ~ end) on "where T <: Sortable;" correctly "017a1"
test (whereClause ~ end) on "where T <: Foo[[A,B]];" correctly "017a2"
test (whereClause ~ end) on "where T <: Foo[[A,B]]; where T <: Sortable[[T]];" correctly "017a3"
testProgramOn "method foo[[T]](a) where T <: Foo; \{a; b; c\}" correctly "017c1"
testProgramOn "method foo[[TER,MIN,US]](a, b, c) where TERM <: MIN <: US; \{a; b; c\}" correctly "017c2"
testProgramOn "method foo[[TXE]](a : T) where TXE <: TXE; \{a; b; c\}" correctly "017c3"
testProgramOn "method foo[[T,U,V]](a : T, b : T, c : T) -> T where T <: X[[T]]; \{a; b; c\}" correctly "017c4"
testProgramOn "method foo[[T,U]](a : T, b : T, c : T) foo(a : T, b : T, c : T) -> T where T <: T; \{a; b; c\}" correctly "017c6"
testProgramOn "class Foo[[A]](a : A, b : B) new(a : A, b : B) where T <: X; \{ a; b; c;  \}" correctly "017f"
testProgramOn "class Foo[[A, B]](a : A, b : B) where A <: B; \{ a; b; c;  \}" correctly "017g1"
testProgramOn "class Foo[[A, B]](a : A, b : B) where A <: B; where A <: T[[A,V,\"Foo\"]]; \{ a; b; c;  \}" correctly "017g2"
testProgramOn "class Foo[[A, B]](a : A, b : B) where A <: B; where A <: T[[A,V,\"Foo\"]]; \{ method a where T <: X; \{ \}; method b(a : Q) where T <: X; \{ \}; method c where SelfType <: Sortable[[Foo]]; \{ \} \}" correctly "017g3"

