package T::std

import T::std::Map
import T::std::MapEntry
import T::std::Iterator
import T::std::Iterable

class HashMap<K, V>: Map<K, V> =

	val static DEFAULT_INITIAL_CAPACITY = 16
	val static DEFAULT_LOAD_FACTOR = 0.75

	var entries: HashMapEntry<K, V>?[]
	var size: Int
	var loadFactor: Double
	var capacity: Int

	Def new()                                         = init(DEFAULT_INITIAL_CAPACITY, DEFAULT_LOAD_FACTOR)
	Def new(initialCapacity: Int)                     = init(initialCapacity, DEFAULT_LOAD_FACTOR)
	Def new(initialCapacity: Int, loadFactor: Double) = init(initialCapacity, loadFactor)
	Def implicit new(entries: MapEntry<K, V>[]) =
		init(DEFAULT_INITIAL_CAPACITY, DEFAULT_LOAD_FACTOR)
		for(val e in entries)
			Add(e)

	Def implicit new(entries: Object[][]) =
		init(DEFAULT_INITIAL_CAPACITY, DEFAULT_LOAD_FACTOR)
		for(val e in entries)
			if(e.Size() != 2)
				error("Invalid size of map entry: " + e.Size() + ", expected 2.")

			if(!(e[0] is K))
				error("Entry has wrong key type!")

			if(!(e[1] is V))
				error("Entry has wrong value type!")

			Add(e[0] as K, e[1] as V)

	Def new(map: HashMap<K, V>) =
		init(map.capacity, map.loadFactor)
		AddAll(map)

	Def new(map: Map<K, V>) =
		init(DEFAULT_INITIAL_CAPACITY, DEFAULT_LOAD_FACTOR)
		AddAll(map)

	Def Size() = size
	Def Capacity() = capacity
	Def Clear() =
		entries = new HashMapEntry<K, V>?[capacity]
		size = 0

	Def Add(key: K, value: V) =
		if(size >= loadFactor * capacity)
			resize()

		val hash = #key
		val newEntry = new HashMapEntry<K, V>(key, value, hash)
		val index = index(hash, capacity)
		if(addTo(entries, index, newEntry))
			size++

	Def Get(key: K) =
		val entry = entries[index(#key, capacity)]
		if(!entry)
			return null

		for(val e in entry)
			if(e.Key() == key)
				return e.Value()

		null

	Def Remove(key: K): Bool =
		val index = index(#key, capacity)
		val entry = entries[index]

		if(!entry)
			return false

		val it = entry.Iterator()
		var previous: HashMapEntry<K, V>? = null
		while(it.HasNext())
			val e = it.Next()
			if(e.Key() == key)
				break

			previous = e

		if(!previous)
			entries[index] = null
		else if(it.HasNext())
			previous.Next = it.Next()
		else
			previous.Next = null

		size--
		true

	Def Iterator() = new EntryIterator<K, V>(entries, this)
	Def Keys()     = new KeyIterator<K, V>(entries, this)
	Def Values()   = new ValueIterator<K, V>(entries, this)

	Def toString() = IsEmpty() ? "[]" : "[ " + MakeString(", ") + " ]"

	def init(initialCapacity: Int, loadFactor: Double) =
		if(initialCapacity % 2 == 0)
			capacity = initialCapacity
		else
			capacity = closestPowerOfTwo(initialCapacity)
		this.loadFactor = loadFactor
		Clear()

	def addTo(data: HashMapEntry<K, V>?[], index: Int, newEntry: HashMapEntry<K, V>) =
		val startingEntry = data[index]

		if(!startingEntry)
			data[index] = newEntry
			return true

		// This should be a do while loop
		var entry: HashMapEntry<K, V>? = null
		for(val v in startingEntry)
			if(v.Key() == newEntry.Key())
				v.SetValue(newEntry.Value())
				return false
			entry = v

		// Will always iterate once since startingEntry was defined, hence entry will be defined
		entry!!.Next = newEntry
		true

	def resize() =
		val newCapacity = capacity << 1
		val newData = new HashMapEntry<K, V>?[newCapacity]

		for(val entry in entries)
			if(!entry)
				continue

			for(val e in entry)
				val index = index(entry.Hash, newCapacity)
				e.Next = null
				addTo(newData, index, e)

		entries = newData
		capacity = newCapacity

	def closestPowerOfTwo(value: Int) =
		for(var i = 2; ; i <<= 1)
			if(i >= value)
				return i
		return -1

	def index(hashCode: Int, capacity: Int) = improvedHash(hashCode) & capacity - 1

	def improvedHash(hash: Int) =
		var h = hash
		h ^= (h >> 20) ^ (h >> 12)
		h ^ (h >> 7) ^ (h >> 4)


class HashMapEntry<K, V>: MapEntry<K, V>, Iterable<HashMapEntry<K, V>> =

	var key: K
	var value: V
	Var Hash: Int
	Var Next: HashMapEntry<K, V>?

	Def new(key: K, value: V)            = init(key, value, 0)
	Def new(key: K, value: V, hash: Int) = init(key, value, hash)

	Def Key() = key
	Def Value() = value

	Def SetKey(key: K)     = (this.key = key)
	Def SetValue(value: V) = (this.value = value)

	Def Iterator() = new EntryListIterator<K, V>(this)

	Def ==(lhs: HashMapEntry<K, V>, rhs: HashMapEntry<K, V>) =
		lhs.key == rhs.key &&
		lhs.value == rhs.value

	Def toString() = "(" + key + " -> " + value + ")"

	def init(key: K, value: V, hash: Int) =
		this.key = key
		this.value = value
		Hash = hash


class EntryListIterator<K, V>: Iterator<HashMapEntry<K, V>> =

	var hasNext: Bool
	var current: HashMapEntry<K, V>

	Def new(startEntry: HashMapEntry<K, V>) =
		hasNext = true
		current = startEntry

	Def HasNext() = hasNext

	Def Next() =
		val res = current
		hasNext = current.Next != null
		if(hasNext)
			current = current.Next!!
		res


class KeyIterator<K, V>: Iterator<K> =

	var it: EntryIterator<K, V>

	Def new(entries: HashMapEntry<K, V>?[], map: HashMap<K, V>) =
		it = new EntryIterator<K, V>(entries, map)

	Def HasNext() = it.HasNext()
	Def Next() = it.Next().Key()


class ValueIterator<K, V>: Iterator<V> =

	var it: EntryIterator<K, V>

	Def new(entries: HashMapEntry<K, V>?[], map: HashMap<K, V>) =
		it = new EntryIterator<K, V>(entries, map)

	Def HasNext() = it.HasNext()
	Def Next() = it.Next().Value()


class EntryIterator<K, V>: Iterator<MapEntry<K, V>> =

	var hasNext: Bool
	var currentEntry: HashMapEntry<K, V>?
	var currentIndex: Int
	var entries: HashMapEntry<K, V>?[]
	var map: HashMap<K, V>

	Def new(entries: HashMapEntry<K, V>?[], map: HashMap<K, V>) =
		this.map = map
		this.entries = entries
		hasNext = map.NonEmpty()
		currentEntry = nextDefinedEntry()

	Def HasNext() = hasNext

	Def Next() =
		val res = currentEntry!!
		currentEntry = nextEntry()
		hasNext = currentEntry != null
		res

	def nextEntry() =
		val c = currentEntry
		if(c && c.Next)
			return c.Next

		nextDefinedEntry()

	def nextDefinedEntry() =
		for(; currentIndex < map.Capacity(); currentIndex++)
			if(!entries[currentIndex])
				continue

			return entries[currentIndex++]

		null
