import "platform/memory" as mxm
def mem = mxm //KERNAN

def ProgrammingError is public  = Exception.refine "ProgrammingError"

def BoundsError is public  = ProgrammingError.refine "BoundsError"
def IteratorExhausted is public = ProgrammingError.refine "IteratorExhausted"
def SubobjectResponsibility is public = ProgrammingError.refine "SubobjectResponsibility"
def NoSuchObject is public = ProgrammingError.refine "NoSuchObject"
def RequestError is public = ProgrammingError.refine "RequestError"
def ConcurrentModification is public = ProgrammingError.refine "ConcurrentModification"
def SizeUnknown is public = Exception.refine "SizeUnknown"

//kjx hacks for Kernan
method sizeOfVariadicList( l ) { 
  var s := 0
  for (l) do { _ -> s := s + 1 } 
  return s
}



method abstract {
    // repeated in StandardPrelude
    SubobjectResponsibility.raise "abstract method not overriden by subobject"
}

type Block0<R> = type {
    apply -> R
}

type Block1<T,R> = type {
    apply(a:T) -> R
}

type Block2<S,T,R> = type {
    apply(a:S, b:T) -> R
}

type Self = Unknown     // becuase it's not yet in the language
type Object = type { }  //KERNAN


type Iterable<T> = Object & type {
    iterator -> Iterator<T>
        // the iterator on which I am based
    isEmpty -> Boolean
        // true if I have no elements
    first -> T
        // my first element; raises BoundsError if I have none.
    do(block1: Block1<T, Done>) -> Done
        // an internal iterator; applies block1 to each of my elements
    do(body:Block1<T, Done>) separatedBy(separator:Block0<Done>) -> Done
        // an internal iterator; ; applies block1 to each of my elements, and applies separator in between
    ++(other: Iterable<T>) -> Iterable<T>
        // returns a new iterator over the concatenation of self and other
    fold(binaryFunction:Block2<T, T, T>) startingWith(initial:T) -> Object
        // the left-associative fold of binaryFunction over self, starting with initial
    map<U>(function:Block1<T, U>) -> Iterator<U>
        // returns a new iterator that yields my elements mapped by function
    filter(condition:Block1<T,Boolean>) -> Iterator<T>
        // returns a new iterator that yields those of my elements for which condition holds 
}

type Expandable<T> = Iterable<T> & type {
    add(*x: T) -> Self
    addAll(xs: Iterable<T>) -> Self
}

type Collection<T> = Iterable<T> & type {
    asList -> List<T>
    asSequence -> Sequence<T>
    asSet -> Set<T>
}

type Enumerable<T> = Collection<T> & type {
    values -> Collection<T>
    asDictionary -> Dictionary<Number,T>
    keysAndValuesDo(action:Block2<Number,T,Object>) -> Done
    onto(resultFactory:EmptyCollectionFactory<T>) -> Collection<T>
    into(existing: Expandable<Unknown>) -> Collection<Unknown>
    sortedBy(comparison:Block2<T,T,Number>) -> Self
    sorted -> Self
}

type Sequence<T> = Enumerable<T> & type {
    size -> Number
    at(n:Number) -> T
    [ n:Number ] -> T            //kernan
    indices -> Sequence<Number>
    keys -> Sequence<Number>
    second -> T
    third -> T
    fourth -> T
    fifth -> T
    last -> T
    indexOf<W>(elem:T)ifAbsent(action:Block0<W>) -> Number | W
    indexOf(elem:T) -> Number
    contains(elem:T) -> Boolean
    reversed -> Sequence<T>
}

type List<T> = Sequence<T> & type {
    add(*x: T) -> List<T>
    addAll(xs: Iterable<T>) -> List<T>
    addFirst(*x: T) -> List<T>
    addAllFirst(xs: Iterable<T>) -> List<T>
    addLast(*x: T) -> List<T>    // same as add
    at(ix:Number) put(v:T) -> List<T>
    //[]:= (ix:Number, v:T) -> Done  // KERNAN
    removeFirst -> T
    removeAt(n: Number) -> T
    removeLast -> T
    remove(*v:T)
    remove(*v:T) ifAbsent(action:Block0<Done>)
    removeAll(vs: Iterable<T>)
    removeAll(vs: Iterable<T>) ifAbsent(action:Block0<Unknown>)
    pop -> T
    ++(o: List<T>) -> List<T>
    addAll(l: Iterable<T>) -> List<T>
    copy -> List<T>
    sort -> List<T>
    sortBy(sortBlock:Block2<T,T,Number>) -> List<T>
    reverse -> List<T>
    reversed -> List<T>
}

type Set<T> = Collection<T> & type {
    size -> Number
    add(*elements:T) -> Self
    addAll(elements: Iterable<T>) -> Self
    remove(*elements: T) -> Set<T>
    remove(*elements: T) ifAbsent(block: Block0<Done>) -> Set<T>
    includes(booleanBlock: Block1<T,Boolean>) -> Boolean
    find(booleanBlock: Block1<T,Boolean>) ifNone(notFoundBlock: Block0<T>) -> T
    copy -> Set<T>
    contains(elem:T) -> Boolean
    ** (other:Set<T>) -> Set<T>
    -- (other:Set<T>) -> Set<T>
    ++ (other:Set<T>) -> Set<T>
    removeAll(elems: Iterable<T>)
    removeAll(elems: Iterable<T>)ifAbsent(action:Block0<Done>) -> Set<T>
    onto(resultFactory:EmptyCollectionFactory<T>) -> Collection<T>
    into(existing: Expandable<Unknown>) -> Collection<Unknown>
}

type Dictionary<K,T> = Collection<T> & type {
    size -> Number
    containsKey(k:K) -> Boolean
    containsValue(v:T) -> Boolean
    contains(elem:T) -> Boolean
    at(key:K)ifAbsent(action:Block0<Unknown>) -> Unknown
    at(key:K)put(value:T) -> Dictionary<K,T>
    // []:= (k:K, v:T) -> Done // KERNAN
    at(k:K) -> T
    [ k:K ] -> T //kernan
    removeAllKeys(keys: Iterable<K>) -> Dictionary<K,T>
    removeKey(*keys:K) -> Dictionary<K,T>
    removeAllValues(removals: Iterable<T>) -> Dictionary<K,T>
    removeValue(*removals:T) -> Dictionary<K,T>
    keys -> Enumerable<K>
    values -> Enumerable<T>
    bindings -> Enumerable<Binding<K,T>>
    keysAndValuesDo(action:Block2<K,T,Done>) -> Done
    keysDo(action:Block1<K,Done>) -> Done
    valuesDo(action:Block1<T,Done>) -> Done
    == (other:Object) -> Boolean
    copy -> Dictionary<K,T>
    ++ (other:Dictionary<K, T>) -> Dictionary<K, T>
    -- (other:Dictionary<K, T>) -> Dictionary<K, T>
    asDictionary -> Dictionary<K, T>
}

type Iterator<T> = type {
    hasNext -> Boolean
    next -> T
}

type CollectionFactory<T> = type {
    withAll (elts: Iterable<T>) -> Collection<T>
    with (*elts:Object) -> Collection<T>
    empty -> Collection<T>
}

type EmptyCollectionFactory<T> = type {
    empty -> Collection<T>
}

trait collectionFactoryTrait<T> {
    method withAll(elts: Iterable<T>) -> Collection<T> { abstract }
    method with(*a:T) -> Unknown { self.withAll(a) }
    method empty -> Unknown { self.with() }
}

class lazySequenceOver<T,R>(source: Iterable<T>)
        mappedBy(function:Block1<T,R>) -> Enumerable<R> is confidential {
    inherits enumerableTrait<T>
    class iterator {
        def sourceIterator = source.iterator
        method asString { "an iterator over a lazy map sequence" }
        method hasNext { sourceIterator.hasNext }
        method next { function.apply(sourceIterator.next) }
    }
    method size { source.size }
    method isEmpty { source.isEmpty }
    method asDebugString { "a lazy sequence mapping over {source}" }
}

class lazySequenceOver<T>(source: Iterable<T>)
        filteredBy(predicate:Block1<T,Boolean>) -> Enumerable<T> is confidential {
    inherits enumerableTrait<T>
    class iterator {
        var cache
        var cacheLoaded := false
        def sourceIterator = source.iterator
        method asString { "an iterator over filtered {source}" }
        method hasNext {
        // To determine if this iterator has a next element, we have to find
        // an acceptable element; this is then cached, for the use of next
            if (cacheLoaded) then { return true }
            try {
                cache := nextAcceptableElement
                cacheLoaded := true
            } catch { ex:IteratorExhausted -> return false }
            return true
        }
        method next {
            if (cacheLoaded.not) then { cache := nextAcceptableElement }
            cacheLoaded := false
            return cache
        }
        method nextAcceptableElement is confidential {
        // return the next element of the underlying iterator satisfying
        // predicate; if there is none, raises IteratorExhausted.
            while { true } do {
                def outerNext = sourceIterator.next
                def acceptable = predicate.apply(outerNext)
                if (acceptable) then { return outerNext }
            }
        }
    }
    method asDebugString { "a lazy sequence filtering {source}" }
}

class iteratorConcat<T>(left:Iterator<T>, right:Iterator<T>) {
    method next {
        if (left.hasNext) then {
            left.next
        } else {
            right.next
        }
    }
    method hasNext {
        if (left.hasNext) then { return true }
        return right.hasNext
    }
    method asDebugString { "iteratorConcat of {left} and {right}" }
    method asString { "an iterator over a concatenation" }
}
class lazyConcatenation<T>(left, right) -> Enumerable<T>{
    inherits enumerableTrait<T>
       alias superAsString = asString
    method iterator {
        iteratorConcat(left.iterator, right.iterator)
    }
    method asDebugString { "lazy concatenation of {left} and {right}" }
    method asString { superAsString }
    method size { left.size + right.size }  // may raise SizeUnknown
}

trait collectionTrait<T> {
    method !=(other) { ! (self == other) }  //KERNAN
    method do { abstract }
    method iterator { abstract }
    method isEmpty {
        // override if size is known
        iterator.hasNext.not
    }
    method first {
        def it = self.iterator
        if (it.hasNext) then { 
            it.next
        } else {
            BoundsError.raise "no first element in {self}"
        }
    }
    method do(block1) separatedBy(block0) {
        var firstTime := true
        var i := 0
        self.do { each ->
            if (firstTime) then {
                firstTime := false
            } else {
                block0.apply
            }
            block1.apply(each)
        }
        return self
    }
    method reduce(initial, blk) {
    // deprecated; for compatibility with builtInList
        fold(blk)startingWith(initial)
    }
    method fold(blk)startingWith(initial) {
        var result := initial
        self.do {it ->
            result := blk.apply(result, it)
        }
        return result
    }
    method map<R>(block1:Block1<T,R>) -> Enumerable<R> {
        lazySequenceOver(self) mappedBy(block1)
    }
    method filter(selectionCondition:Block1<T,Boolean>) -> Enumerable<T> {
        lazySequenceOver(self) filteredBy(selectionCondition)
    }

    method iter { self.iterator }

    method asSequence {
        sequence.withAll(self)
    }
    method asList {
        list.withAll(self)
    }
    method asSet {
        set.withAll(self)
    }
}

trait enumerableTrait<T> {
    uses collectionTrait<T>
    method iterator { abstract }
    method size {
        // override if size is known
        SizeUnknown.raise "size requested on {asDebugString}"
    }
    method asDictionary {
        def result = dictionary.empty
        keysAndValuesDo { k, v ->
            result.at(k) put(v)
        }
        return result
    }
    method onto(f: CollectionFactory<T>) -> Collection<T> {
        f.withAll(self)
    }
    method into(existing: Expandable<T>) -> Collection<T> {
        def selfIterator = self.iterator
        while {selfIterator.hasNext} do {
            existing.add(selfIterator.next)
        }
        existing
    }
    method ==(other) {
        isEqual (self) toIterable (other)
    }
    method do(block1:Block1<T,Done>) -> Done {
        def selfIterator = self.iterator
        while {selfIterator.hasNext} do {
            block1.apply(selfIterator.next)
        }
    }
    method keysAndValuesDo(block2:Block2<Number,T,Done>) -> Done {
        var ix := 0
        def selfIterator = self.iterator
        while {selfIterator.hasNext} do {
            ix := ix + 1
            block2.apply(ix, selfIterator.next)
        }
    }
    method values -> Collection<T> {
        self
    }
    method fold<R>(block2)startingWith(initial) -> R {
        var res := initial
        def selfIterator = self.iterator
        while { selfIterator.hasNext } do {
            res := block2.apply(res, selfIterator.next)
        }
        return res
    }
    method ++ (other) -> Enumerable<T> {
        lazyConcatenation(self, other)
    }
    method sortedBy(sortBlock:Block2) -> List<T> {
        self.asList.sortBy(sortBlock)
    }
    method sorted -> List<T> {
        self.asList.sort
    }
    method asString {
        var s := "⟨"
        do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
        s ++ "⟩"
    }
}

trait indexableTrait<T> {
    uses collectionTrait<T>
    method at { abstract }
    method size { abstract }
    method isEmpty { size == 0 }
    method keysAndValuesDo(action:Block2<Number,T,Done>) -> Done {
        def curSize = size
        var i := 1
        while {i <= curSize} do {
            action.apply(i, self.at(i))
            i := i + 1
        }
    }
    method first { at(1) }
    method second { at(2) }
    method third { at(3) }
    method fourth { at(4) }
    method fifth { at(5) }
    method last { at(size) }
    method [ix] { at(ix) }                //kernan 
    method indices { range.from 1 to(size) }
    method indexOf(sought:T)  {
        indexOf(sought) ifAbsent { NoSuchObject.raise "{sought} not in collection" }
    }
    method indexOf(sought:T) ifAbsent(action:Block0)  {
        keysAndValuesDo { ix, v ->
            if (v == sought) then { return ix }
        }
        action.apply
    }
    method asDictionary {
        def result = dictionary.empty
        keysAndValuesDo { k, v ->
            result.at(k) put(v)
        }
        return result
    }
    method onto(f: CollectionFactory<T>) -> Collection<T> {
        f.withAll(self)
    }
    method into(existing: Expandable<T>) -> Collection<T> {
        def selfIterator = self.iterator
        while {selfIterator.hasNext} do {
            existing.add(selfIterator.next)
        }
        existing
    }
}

method max(a,b) is confidential {       // repeated from standard prelude
    if (a > b) then { a } else { b }
}

def emptySequence is confidential = object {
    inherits indexableTrait
    method size { 0 }
    method isEmpty { true }
    method at(n) { BoundsError.raise "index {n} of empty sequence" }
    method [n] { BoundsError.raise "index {n} of empty sequence" }  //kernan
    method keys { self }
    method values { self }
    method keysAndValuesDo(block2) { done }
    method reversed { self }
    method ++(other: Iterable) { sequence.withAll(other) }
    method asString { "⟨⟩" }
    method contains(element) { false }
    method do(block1) { done }
    method ==(other) {
        match (other)
            case {o: Iterable ->
                o.isEmpty
            }
            case {_ ->
                false
            }
    }
    class iterator {
        method asString { "emptySequenceIterator" }
        method hasNext { false }
        method next { IteratorExhausted.raise "on empty sequence" }
    }
    method sorted { self }
    method sortedBy(sortBlock:Block2){ self }
}

class sequence<T> {
    inherits collectionFactoryTrait<T>

    method empty is override {
        // this is an optimization: there need be just one empty sequence
        emptySequence
    }

    method withAll(*a: Iterable) {
        var forecastSize := 0
        var sizeUncertain := false
        // size might be uncertain if one of the arguments is a lazy collection.
        for (a) do { arg ->
            try {
                forecastSize := forecastSize + arg.size
            } catch { _ -> 
                             forecastSize := forecastSize + 8 //KERNAN
                             sizeUncertain := true //KERNAN
            }
        }
        var inner := mem.allocate(forecastSize)
        var innerSize := inner.size
        var ix := 0
        if (sizeUncertain) then {
            // less-than-optimal path
            for (a) do { arg ->
                for (arg) do { elt ->
                    if (innerSize <= ix) then {
                        def newInner = mem.allocate(innerSize * 2)
                        for (0 .. (innerSize - 1)) do { i ->
                            newInner.at(i)put(inner.at(i))
                        }
                        inner := newInner
                        innerSize := inner.size
                    }
                    inner.at(ix)put(elt)
                    ix := ix + 1
                }
            }
        } else {
            // common, fast path
            for (a) do { arg ->
                for (arg) do { elt ->
                    inner.at(ix)put(elt)
                    ix := ix + 1
                }
            }
        }
        self.fromPrimitiveArray(inner, ix)
    }
    method fromPrimitiveArray(pArray, sz) is confidential {
        // constructs a sequence from the first sz elements of pArray

        object {
            inherits indexableTrait
            method size {sz} //KERNAN BUG
            def inner = pArray

            method boundsCheck(n) is confidential {
                if (!(n >= 1) || !(n <= size)) then {
                    // the condition is written this way because NaN always
                    // compares false
                    BoundsError.raise "index {n} out of bounds 1 .. {size}"
                }
            }
            method at(n) {
                boundsCheck(n)
                inner.at(n - 1)
            }
            method [n] {              //kernan
                boundsCheck(n)
                inner.at(n - 1)
            }
            method keys {
                range.from(1)to(size)
            }
            method values {
                self
            }
            method keysAndValuesDo(block2) {
                var i := 0
                while {i < size} do {
                    block2.apply(i + 1, inner.at(i))
                    i := i + 1
                }
            }
            method reversed {
                def freshArray = mem.allocate(size)
                var ix := size - 1
                do { each ->
                    freshArray.at (ix) put(each)
                    ix := ix - 1
                }
                outer.fromPrimitiveArray(freshArray, size)
            }
            method ++(other: Iterable) {
                sequence.withAll(self, other)
            }
            method asString {
                var s := "⟨"
                for (0 .. (size - 1)) do {i->
                    s := s ++ inner.at(i).asString
                    if (i < (size - 1)) then { s := s ++ ", " }
                }
                s ++ "⟩"
            }
            method contains(element) {
                do { each -> if (each == element) then { return true } }
                return false
            }
            method do(block1) {
                var i := 0
                while {i < size} do {
                    block1.apply(inner.at(i))
                    i := i + 1
                }
            }
            method ==(other) {
                isEqual (self) toIterable (other)
            }
            method iterator {
                object {
                    var idx := 1
                    method asDebugString { "{asString}⟪{idx}⟫" }
                    method asString { "aSequenceIterator" }
                    method hasNext { idx <= sz }
                    method next {
                        if (idx > sz) then { IteratorExhausted.raise "on sequence {outer.asString}⟪{idx}⟫" }
                        def ret = at(idx)
                        idx := idx + 1
                        ret
                    }
                }
            }
            method sorted {
                asList.sortBy { l, r ->
                    if (l == r) then {0}
                        elseif (l < r) then {-1}
                        else {1}
                }.asSequence
            }
            method sortedBy(sortBlock:Block2){
                asList.sortBy(sortBlock).asSequence
            }
        }
    }
}

method isEqual(left) toIterable(right) {
    if (Iterable.match(right)) then {
        def leftIter = left.iterator
        def rightIter = right.iterator
        while {leftIter.hasNext && rightIter.hasNext} do {
            if (leftIter.next != rightIter.next) then {
                return false
            }
        }
        leftIter.hasNext == rightIter.hasNext
    } else { 
        false
    }
}

class list<T> {
    inherits collectionFactoryTrait<T>

    method withAll(a: Iterable<T>) -> List<T> {

        object {
            // the new list object without native code
            inherits indexableTrait<T>
            method size { sz } 
            method size:=(x) { sz := x }
            var sz is readable := 0 //KERNAN moved up from below
            var mods is readable := 0
            var initialSize
            try { initialSize := sizeOfVariadicList(a) * 2 + 1 }
                catch { _ex:SizeUnknown -> initialSize := 9 }
            var inner := mem.allocate(initialSize)

            for (a) do {x->
                inner.at(size)put(x)
                size := size + 1
            }
            method boundsCheck(n) is confidential {
                if ( !(n >= 1) || !(n <= size)) then {
                    BoundsError.raise "index {n} out of bounds 1 .. {size}"
                }
            }
            method at(n) {
                boundsCheck(n)
                inner.at(n - 1)
            }
            method [n] {
                boundsCheck(n)
                inner.at(n - 1)
            }
            method at(n)put(x) {
                mods := mods + 1
                if (n == (size + 1)) then {
                    addLast(x)
                } else {
                    boundsCheck(n)
                    inner.at(n - 1)put(x)
                }
                self
            }
            method [n] := (x) {
                mods := mods + 1
                if (n == (size + 1)) then {
                    addLast(x)
                } else {
                    boundsCheck(n)
                    inner.at(n - 1)put(x)
                }
                done
            }
            method add(*x) {
                addAll(x)
            }
            method addAll(l) {
                mods := mods + 1
                if ((size + sizeOfVariadicList(l)) > inner.size) then {
                    expandTo(max(size + sizeOfVariadicList(l), size * 2))
                }
                for (l) do {each ->
                    inner.at(size)put(each)
                    size := size + 1
                }
                self
            }
            method push(x) {
                mods := mods + 1
                if (size == inner.size) then { expandTo(inner.size * 2) }
                inner.at(size)put(x)
                size := size + 1
                self
            }
            method addLast(*x) { addAll(x) }    // compatibility
            method removeLast {
                mods := mods + 1
                def result = inner.at(size - 1)
                size := size - 1
                result
            }
            method addAllFirst(l) {
                mods := mods + 1
                def increase = l.size
                if ((size + increase) > inner.size) then {
                    expandTo(max(size + increase, size * 2))
                }
                for (range.from(size - 1)downTo(0)) do {i->
                    inner.at(i + increase)put(inner.at(i))
                }
                var insertionIndex := 0
                for (l) do {each ->
                    inner.at(insertionIndex)put(each)
                    insertionIndex := insertionIndex + 1
                }
                size := size + increase
                self
            }
            method addFirst(*l) { addAllFirst(l) }
            method removeFirst {
                removeAt(1)
            }
            method removeAt(n) {
                mods := mods + 1
                boundsCheck(n)
                def removed = inner.at(n - 1)
                for (n .. (size - 1)) do {i->
                    inner.at(i - 1)put(inner.at(i))
                }
                size := size - 1
                return removed
            }
            method remove(*v:T) {
                removeAll(v)
            }
            method remove(*v:T) ifAbsent(action:Block0<Done>) {
                removeAll(v) ifAbsent (action)
            }
            method removeAll(vs: Iterable<T>) {
                removeAll(vs) ifAbsent { NoSuchObject.raise "object not in list" }
            }
            method removeAll(vs: Iterable<T>) ifAbsent(action:Block0<Done>)  {
                for (vs) do { each ->
                    def ix = indexOf(each) ifAbsent { 0 }
                    if (ix ≠ 0) then {
                        removeAt(ix)
                    } else {
                        action.apply
                    }
                }
                self
            }
            method pop { removeLast }
            method reversed {
                def result = list.empty
                do { each -> result.addFirst(each) }
                result
            }
            method reverse {
                mods := mods + 1
                var hiIx := size
                var loIx := 1
                while {loIx < hiIx} do {
                    def hiVal = self.at(hiIx)
                    self.at(hiIx) put (self.at(loIx))
                    self.at(loIx) put (hiVal)
                    hiIx := hiIx - 1
                    loIx := loIx + 1
                }
                self
            }
            method ++(o) {
                def l = list.withAll(self)
                l.addAll(o)
            }
            method asString {
                var s := "["
                for (0 .. (size - 1)) do {i->
                    s := s ++ inner.at(i).asString
                    if (i < (size - 1)) then { s := s ++ ", " }
                }
                s ++ "]"
            }
            method contains(element) {
                do { each -> if (each == element) then { return true } }
                return false
            }
            method do(block1) {
                var i := 0
                while {i < size} do {
                    block1.apply(inner.at(i))
                    i := i + 1
                }
            }

            method ==(other) {
                isEqual (self) toIterable (other)
            }
            method iterator {
                object {
                    var imods := mods
                    var idx := 1
                    method asDebugString { "{asString}⟪{idx}⟫" }
                    method asString { "aListIterator" }
                    method hasNext { idx <= size }
                    method next {
                        if (imods != mods) then {
                            ConcurrentModification.raise (asDebugString)
                        }
                        if (idx > size) then { IteratorExhausted.raise "on list" }
                        def ret = at(idx)
                        idx := idx + 1
                        ret
                    }
                }
            }
            method values {
                self
            }
            method keys {
                self.indices
            }
            method expandTo(newSize) is confidential {
                def newInner = mem.allocate(newSize)
                for (0 .. (size -  1)) do {i->
                    newInner.at(i)put(inner.at(i))
                }
                inner := newInner
            }
            method sortBy(sortBlock:Block2) {
                mods := mods + 1
                // inner.sortInitial(size) by(sortBlock) //KERNNA: WTF???
                
                self
            }
            method sort {
                sortBy { l, r ->
                    if (l == r) then {0}
                        elseif (l < r) then {-1}
                        else {1}
                }
            }
            method sortedBy(sortBlock:Block2) {
                copy.sortBy(sortBlock)
            }
            method sorted {
                copy.sort
            }
            method copy {
                outer.withAll(self)
            }
        }
    }
}


class set<T> {
    inherits collectionFactoryTrait<T>

    method withAll(a: Iterable<T>) -> Set<T> {
        object {
            inherits collectionTrait
            var mods is readable := 0
            var initialSize
            try { initialSize := max(sizeOfVariadicList(a) * 3 + 1, 8) }
                catch { _:SizeUnknown -> initialSize := 8 }
            var inner := mem.allocate(initialSize)
            def unused = object {
                var unused := true
                method asString { "unused" }
            }
            def removed = object {
                var removed := true
                method asString { "removed" }
            }
            method size {sz} //KERNAN BUG
            method size:=(x) { sz := x } //KERNSAN BUG
            var sz := 0
            for (0 .. (initialSize - 1)) do {i->
                inner.at(i)put(unused)
            }
            for (a) do { x-> add(x) }

            method addAll(elements) {
                mods := mods + 1
                for (elements) do { x ->
                    if (! contains(x)) then {
                        def t = findPositionForAdd(x)
                        inner.at(t)put(x)
                        size := size + 1
                        if (size > (inner.size / 2)) then {
                            expand
                        }
                    }
                }
                self    // for chaining
            }

            method add(*elements) { addAll(elements) }

            method removeAll(elements) {
                for (elements) do { x ->
                    remove (x) ifAbsent {
                        NoSuchObject.raise "set does not contain {x}"
                    }
                }
                self    // for chaining
            }
            method removeAll(elements)ifAbsent(block) {
                mods := mods + 1
                for (elements) do { x ->
                    var t := findPosition(x)
                    if (inner.at(t) == x) then {
                        inner.at(t) put (removed)
                        size := size - 1
                    } else {
                        block.apply
                    }
                }
                self    // for chaining
            }

            method remove(*elements)ifAbsent(block) {
                removeAll(elements) ifAbsent(block)
            }

            method remove(*elements) {
                removeAll(elements)
            }

            method contains(x) {
                var t := findPosition(x)
                if (inner.at(t) == x) then {
                    return true
                }
                return false
            }
            method includes(booleanBlock) {
                self.do { each ->
                    if (booleanBlock.apply(each)) then { return true }
                }
                return false
            }
            method find(booleanBlock)ifNone(notFoundBlock) {
                self.do { each ->
                    if (booleanBlock.apply(each)) then { return each }
                }
                return notFoundBlock.apply
            }
            method findPosition(x) is confidential {
                def h = x.hash
                def s = inner.size
                var t := h % s
                var jump := 5
                var candidate
                while {
                    candidate := inner.at(t)
                    candidate != unused
                } do {
                    if (candidate == x) then {
                        return t
                    }
                    if (jump != 0) then {
                        t := (t * 3 + 1) % s
                        jump := jump - 1
                    } else {
                        t := (t + 1) % s
                    }
                }
                return t
            }
            method findPositionForAdd(x) is confidential {
                def h = x.hash
                def s = inner.size
                var t := h % s
                var jump := 5
                var candidate
                while {
                    candidate := inner.at(t)
                    (candidate != unused).andAlso{candidate != removed}
                } do {
                    if (candidate == x) then {
                        return t
                    }
                    if (jump != 0) then {
                        t := (t * 3 + 1) % s
                        jump := jump - 1
                    } else {
                        t := (t + 1) % s
                    }
                }
                return t
            }

            method asString {
                var s := "set\{"
                do {each -> s := s ++ each.asString }
                    separatedBy { s := s ++ ", " }
                s ++ "\}"
            }
            method extend(l) {
                for (l) do {i->
                    add(i)
                }
            }
            method do(block1) {
                var i := 0
                var found := 0
                var candidate
                while {found < size} do {
                    candidate := inner.at(i)
                    if ((candidate != unused).andAlso{candidate != removed}) then {
                        found := found + 1
                        block1.apply(candidate)
                    }
                    i := i + 1
                }
            }
            method iterator {
                object {
                    var imods:Number := mods
                    var count := 1
                    var idx := -1
                    method hasNext { size >= count }
                    method next {
                        var candidate
                        def innerSize = inner.size
                        while {
                            idx := idx + 1
                            if (imods != mods) then {
                                ConcurrentModification.raise (outer.asString)
                            }
                            if (idx >= innerSize) then {
                                IteratorExhausted.raise "iterator over {outer.asString}"
                            }
                            candidate := inner.at(idx)
                            (candidate == unused).orElse{candidate == removed}
                        } do { }
                        count := count + 1
                        candidate
                    }
                }
            }

            method expand is confidential {
                def c = inner.size
                def n = c * 2
                def oldInner = inner
                size := 0
                inner := mem.allocate(n)
                for (0 .. (inner.size - 1)) do {i->
                    inner.at(i)put(unused)
                }
                for (0 .. (oldInner.size - 1)) do {i->
                    if ((oldInner.at(i) != unused).andAlso{oldInner.at(i) != removed}) then {
                        add(oldInner.at(i))
                    }
                }
            }
            method ==(other) {
                if (Iterable.match(other)) then {
                    var otherSize := 0
                    other.do { each ->
                        otherSize := otherSize + 1
                        if (! self.contains(each)) then {
                            return false
                        }
                    }
                    otherSize == self.size
                } else { 
                    false
                }
            }
            method copy {
                outer.withAll(self)
            }
            method ++ (other) {
            // set union
                copy.addAll(other)
            }
            method -- (other) {
            // set difference
                def result = set.empty
                for (self) do {v->
                    if (!other.contains(v)) then {
                        result.add(v)
                    }
                }
                result
            }
            method ** (other) {
            // set intersection
                (filter {each -> other.contains(each)}).asSet
            }
            method isSubset(s2: Set<T>) {
                self.do{ each ->
                    if (s2.contains(each).not) then { return false }
                }
                return true
            }

            method isSuperset(s2: Iterable<T>) {
                s2.do{ each ->
                    if (self.contains(each).not) then { return false }
                }
                return true
            }
            method onto(f: CollectionFactory<T>) -> Collection<T> {
                f.withAll(self)
            }
            method into(existing: Expandable<T>) -> Collection<T> {
                do { each -> existing.add(each) }
                existing
            }
        }
    }
}

type Binding<K,T> = {
    key -> K
    value -> T
    hash -> Number
    == (x) -> Boolean
}

class key(k)value(v) {
    method key {k}
    method value {v}
    method asString { "{k} :: {v}" }
    method hashcode { (k.hashcode * 1021) + v.hashcode }
    method hash { (k.hash * 1021) + v.hash }
    method == (other) {
        match (other)
            case {o:Binding -> (k == o.key) && (v == o.value) }
            case {_ -> return false }
    }
}

class dictionary<K,T> {
    inherits collectionFactoryTrait<T>
    method at(k:K)put(v:T) {
            self.empty.at(k)put(v)
    }
    method withAll(initialBindings: Iterable<Binding<K,T>>) -> Dictionary<K,T> {
        object {
            inherits collectionTrait<T>
            var mods is readable := 0
            var numBindings := 0
            var inner := mem.allocate(8)
            def unused = object {
                var unused := true
                def key is public = self
                def value is public = self
                method asString { "unused" }
            }
            def removed = object {
                var removed := true
                def key is public = self
                def value is public = self
                method asString { "removed" }
            }
            for (0 .. (inner.size - 1)) do {i->
                inner.at(i)put(unused)
            }
            for (initialBindings) do { b -> at(b.key)put(b.value) }
            method size { numBindings }
            method at(key')put(value') {
                mods := mods + 1
                var t := findPositionForAdd(key')
                if ((inner.at(t) == unused).orElse{inner.at(t) == removed}) then {
                    numBindings := numBindings + 1
                }
                inner.at(t)put(key(key')value(value'))
                if ((size * 2) > inner.size) then { expand }
                self    // for chaining
            }
            method [k] := (v) {
                at(k)put(v)
                done
            }
            method at(k) {
                var b := inner.at(findPosition(k))
                if (b.key == k) then {
                    return b.value
                }
                NoSuchObject.raise "dictionary does not contain entry with key {k}"
            }
            method at(k) ifAbsent(action) {
                var b := inner.at(findPosition(k))
                if (b.key == k) then {
                    return b.value
                }
                return action.apply
            }
            method [k] { at(k) }
            method containsKey(k) {
                var t := findPosition(k)
                if (inner.at(t).key == k) then {
                    return true
                }
                return false
            }
            method removeAllKeys(keys) {
                mods := mods + 1
                for (keys) do { k ->
                    var t := findPosition(k)
                    if (inner.at(t).key == k) then {
                        inner.at(t)put(removed)
                        numBindings := numBindings - 1
                    } else {
                        NoSuchObject.raise "dictionary does not contain entry with key {k}"
                    }
                }
                return self
            }
            method removeKey(*keys) {
                removeAllKeys(keys)
            }
            method removeAllValues(removals) {
                mods := mods + 1
                for (0 .. (inner.size - 1)) do {i->
                    def a = inner.at(i)
                    if (removals.contains(a.value)) then {
                        inner.at(i)put(removed)
                        numBindings := numBindings - 1
                    }
                }
                return self
            }
            method removeValue(*removals) {
                removeAllValues(removals)
            }
            method containsValue(v) {
                self.valuesDo{ each ->
                    if (v == each) then { return true }
                }
                return false
            }
            method contains(v) { containsValue(v) }
            method findPosition(x) is confidential {
                def h = x.hash
                def s = inner.size
                var t := h % s
                var jump := 5
                while {inner.at(t) != unused} do {
                    if (inner.at(t).key == x) then {
                        return t
                    }
                    if (jump != 0) then {
                        t := (t * 3 + 1) % s
                        jump := jump - 1
                    } else {
                        t := (t + 1) % s
                    }
                }
                return t
            }
            method findPositionForAdd(x) is confidential {
                def h = x.hash
                def s = inner.size
                var t := h % s
                var jump := 5
                while {(inner.at(t) != unused).andAlso{inner.at(t) != removed}} do {
                    if (inner.at(t).key == x) then {
                        return t
                    }
                    if (jump != 0) then {
                        t := (t * 3 + 1) % s
                        jump := jump - 1
                    } else {
                        t := (t + 1) % s
                    }
                }
                return t
            }
            method asString {
                // do()separatedBy won't work, because it iterates over values,
                // and we need an iterator over bindings.
                var s := "dict⟬"
                var firstElement := true
                for (0 .. (inner.size - 1)) do {i->
                    def a = inner.at(i)
                    if ((a != unused) && (a != removed)) then {
                        if (! firstElement) then {
                            s := s ++ ", "
                        } else {
                            firstElement := false
                        }
                        s := s ++ "{a.key}::{a.value}"
                    }
                }
                s ++ "⟭"
            }
            method asDebugString {
                var s := "dict⟬"
                for (0 .. (inner.size - 1)) do {i->
                    if (i > 0) then { s := s ++ ", " }
                    def a = inner.at(i)
                    if ((a != unused) && (a != removed)) then {
                        s := s ++ "{i}→{a.key}::{a.value}"
                    } else {
                        s := s ++ "{i}→{a.asDebugString}"
                    }
                }
                s ++ "⟭"
            }
            method keys -> Enumerable<K> {
                def sourceDictionary = self
                object {
                    inherits enumerableTrait<K>
                    class iterator {
                        def sourceIterator = sourceDictionary.bindingsIterator
                        method hasNext { sourceIterator.hasNext }
                        method next { sourceIterator.next.key }
                        method asString {
                            "an iterator over keys of {sourceDictionary}"
                        }
                    }
                    def size is public = sourceDictionary.size
                    method asDebugString {
                        "a lazy sequence over keys of {sourceDictionary}"
                    }
                }
            }
            method values -> Enumerable<T> {
                def sourceDictionary = self
                object {
                    inherits enumerableTrait<T>
                    class iterator {
                        def sourceIterator = sourceDictionary.bindingsIterator
                        // should be request on outer
                        method hasNext { sourceIterator.hasNext }
                        method next { sourceIterator.next.value }
                        method asString {
                            "an iterator over values of {sourceDictionary}"
                        }
                    }
                    def size is public = sourceDictionary.size
                    method asDebugString {
                        "a lazy sequence over values of {sourceDictionary}"
                    }
                }
            }
            method bindings -> Enumerable<T> {
                def sourceDictionary = self
                object {
                    inherits enumerableTrait<T>
                    method iterator { sourceDictionary.bindingsIterator }
                    // should be request on outer
                    def size is public = sourceDictionary.size
                    method asDebugString {
                        "a lazy sequence over bindings of {sourceDictionary}"
                    }
                }
            }
            method iterator -> Iterator<T> { values.iterator }
            class bindingsIterator -> Iterator<Binding<K, T>> {
                // this should be confidential, but can't be until `outer` is fixed.
                def imods:Number = mods
                var count := 1
                var idx := 0
                var elt
                method hasNext { size >= count }
                method next {
                    if (imods != mods) then {
                        ConcurrentModification.raise (outer.asString)
                    }
                    if (size < count) then { IteratorExhausted.raise "over {outer.asString}" }
                    while {
                        elt := inner.at(idx)
                        (elt == unused) || (elt == removed)
                    } do {
                        idx := idx + 1
                    }
                    count := count + 1
                    idx := idx + 1
                    elt
                }
            }
            method expand is confidential {
                def c = inner.size
                def n = c * 2
                def oldInner = inner
                inner := mem.allocate(n)
                for (0 .. (n - 1)) do {i->
                    inner.at(i)put(unused)
                }
                numBindings := 0
                for (0 .. (c - 1)) do {i->
                    def a = oldInner.at(i)
                    if ((a != unused).andAlso{a != removed}) then {
                        self.at(a.key)put(a.value)
                    }
                }
            }
            method keysAndValuesDo(block2) {
                 for (0 .. (inner.size - 1)) do {i->
                    def a = inner.at(i)
                    if ((a != unused).andAlso{a != removed}) then {
                        block2.apply(a.key, a.value)
                    }
                }
            }
            method keysDo(block1) {
                 for (0 .. (inner.size - 1)) do {i->
                    def a = inner.at(i)
                    if ((a != unused).andAlso{a != removed}) then {
                        block1.apply(a.key)
                    }
                }
            }
            method valuesDo(block1) {
                 for (0 .. (inner.size - 1)) do {i->
                    def a = inner.at(i)
                    if ((a != unused).andAlso{a != removed}) then {
                        block1.apply(a.value)
                    }
                }
            }
            method do(block1) { valuesDo(block1) }

            method ==(other) {
                match (other)
                    case {o:Dictionary ->
                        if (self.size != o.size) then {return false}
                        self.keysAndValuesDo { k, v ->
                            if (o.at(k)ifAbsent{return false} != v) then {
                                return false
                            }
                        }
                        return true
                    }
                    case {_ ->
                        return false
                    }
            }

            method copy {
                def newCopy = dictionary.empty
                self.keysAndValuesDo{ k, v ->
                    newCopy.at(k)put(v)
                }
                newCopy
            }

            method asDictionary {
                self
            }

            method ++(other) {
                def newDict = self.copy
                other.keysAndValuesDo {k, v ->
                    newDict.at(k) put(v)
                }
                return newDict
            }

            method --(other) {
                def newDict = dictionary.empty
                keysAndValuesDo { k, v ->
                    if (! other.containsKey(k)) then {
                        newDict.at(k) put(v)
                    }
                }
                return newDict
            }
        }
    }
}

class range {
    method from(lower)to(upper) -> Sequence<Number> {
        object {
            inherits indexableTrait<Number>
            match (lower)
                case {_:Number -> }
                case {_ -> RequestError.raise ( "lower bound {lower}" ++ 
                             " in range.from({lower})to({upper}) is not an integer") }
            def start = lower.integral //KERNAN was integral
            if (start != lower) then {
                RequestError.raise ("lower bound {lower}" ++
                   " in range.from({lower})to({upper}) is not an integer") }

            match (upper)
                case {_:Number -> }
                case {_ -> RequestError.raise ("upper bound {upper}" ++
                             " in range.from({lower})to({upper}) is not an integer") }
            def stop = upper.integral
            if (stop != upper) then {
                RequestError.raise ("upper bound {upper}" ++
                    " in range.from()to() is not an integer")
            }
            method size {sz} //KERNAN BUG
            def sz is public =
                if ((upper - lower + 1) < 0) then { 0 } else {upper - lower + 1}

            def hash is public = { ((start.hash * 1021) + stop.hash) * 3 }

            method iterator -> Iterator {
                object {
                    var val := start
                    method hasNext { val <= stop }
                    method next {
                        if (val > stop) then {
                            IteratorExhausted.raise "over {outer.asString}"
                        }
                        val := val + 1
                        return (val - 1)
                    }
                    method asString { "KJX+HAS+NO+IDEA+superAsString from {upper} to {lower}" }
                }
            }
            method at(ix:Number) {
                if (!(ix <= self.size)) then {
                    BoundsError.raise "requested range.at({ix}), but upper bound is {size}"
                }
                if (!(ix >= 1)) then {
                    BoundsError.raise "requested range.at({ix}), but lower bound is 1"
                }
                return start + (ix - 1)
            }
            method contains(elem) -> Boolean {
                try {
                    def intElem = elem.integral
                    if (intElem != elem) then {return false}
                    if (intElem < start) then {return false}
                    if (intElem > stop) then {return false}
                } catch { ex: Exception -> return false }
                return true
            }
            method do(block1) {
                var val := start
                while {val <= stop} do {
                    block1.apply(val)
                    val := val + 1
                }
            }
            method keysAndValuesDo(block2) {
                var key := 1
                var val := start
                while {val <= stop} do {
                    block2.apply(key, val)
                    key := key + 1
                    val := val + 1
                }
            }
            method reversed {
                from(upper)downTo(lower)
            }
            method ++(other) {
                sequence.withAll(self, other)
            }
            method ==(other) {
                isEqual (self) toIterable (other)
            }
            method sorted { self }

            method sortedBy(c) { self.asList.sortBy(c) }

            method keys { 1 .. self.size }

            method values { self }

            method asString -> String{
                "range.from({lower})to({upper})"
            }

            method asList{
                var result := list.empty
                for (self) do { each -> result.add(each) }
                result
            }

            method asSequence {
                self
            }
        }
    }
    method from(upper)downTo(lower) -> Sequence<Number> {
        object {
            inherits indexableTrait
            match (upper)
                case {_:Number -> }
                case {_ -> RequestError.raise ("upper bound {upper}" ++
                               " in range.from({upper})downTo({lower}) is not an integer") }
            def start = upper.integral
            if (start != upper) then {
                RequestError.raise ("upper bound {upper}" ++
                    " in range.from({upper})downTo({lower}) is not an integer")
            }
            match (lower)
                case {_:Number -> }
                case {_ -> RequestError.raise ("lower bound {lower}" ++
                               " in range.from({upper})downTo({lower}) is not an integer") }
            def stop = lower.integral
            if (stop != lower) then {
                RequestError.raise ("lower bound {lower}" ++
                    " in range.from({upper})downTo({lower}) is not an integer")
            }
            method size {sz} //KERNAN BUG
            def sz is public =
                if ((upper - lower + 1) < 0) then { 0 } else {upper - lower + 1}
            method iterator {
                object {
                    var val := start
                    method hasNext { val >= stop }
                    method next {
                        if (val < stop) then { IteratorExhausted.raise "over {outer.asString}" }
                        val := val - 1
                        return (val + 1)
                    }
                    method asString { "anIterator over {super.asString}" }
                }
            }
            method at(ix:Number) {
                if (!(ix <= self.size)) then {
                    BoundsError.raise "requested range.at({ix}) but upper bound is {size}"
                }
                if (!(ix >= 1)) then {
                    BoundsError.raise "requested range.at({ix}) but lower bound is 1"
                }
                return start - (ix - 1)
            }
            method contains(elem) -> Boolean {
                try {
                    def intElem = elem.integral
                    if (intElem != elem) then {return false}
                    if (intElem > start) then {return false}
                    if (intElem < stop) then {return false}
                } catch { ex: Exception -> return false }
                return true
            }
            method do(block1) {
                var val := start
                while {val >= stop} do {
                    block1.apply(val)
                    val := val - 1
                }
            }
            method keysAndValuesDo(block2) {
                var key := 1
                var val := start
                while {val >= stop} do {
                    block2.apply(key, val)
                    key := key + 1
                    val := val - 1
                }
            }
            method reversed {
                from(lower)to(upper)
            }
            method ++(other) {
                sequence.withAll(self, other)
            }
            method ==(other) {
                isEqual (self) toIterable (other)
            }
            method sorted { self.reversed }

            method sortedBy(c) { self.asList.sortBy(c) }

            method keys { 1 .. self.size }

            method values { self }

            method asString -> String {
                "range.from {upper} downTo {lower}"
            }
            method asSequence {
                self
            }
        }
    }
}
