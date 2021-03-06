package T::std

import T::std::Iterable

trait Collection<T>: Iterable<T> =

	/**
	* Returns the number of elements in the collection.
	* @return the number of elements in the collection
	*/
	Def Size(): Int

	/**
	* Clears the collection. After this method is called Size() will return 0.
	*/
	Def Clear(): Unit

	/**
	* Adds the given value to the collection.
	* @param value the value to add
	*/
	Def Add(value: T): Unit

	/**
	* Removes the given element from this collection.
	* @param value the element to remove
	* @return	  true if the element was removed; false otherwise
	*/
	Def Remove(value: T): Bool

	/**
	* Returns true if the collection contains the given element.
	* @return true if the collection contains the given element; false otherwise
	*/
	Def Contains(value: T): Bool

	//------------------------------------------------------------
	// Default methods
	//------------------------------------------------------------

	/**
	* Returns true if the collection is empty.
	* @return true if the collection is empty; false otherwise
	*/
	Def IsEmpty(): Bool = Size() == 0

	/**
	* Returns true if the list is not empty.
	* @return true if the list is not empty; false otherwise
	*/
	Def NonEmpty(): Bool = Size() > 0

	/**
	* Adds all the elements in the given collection to this collection.
	* @param list the collection of elements to add
	*/
	Def AddAll(elements: Collection<T>): Unit =
		for(val e in elements)
			Add(e)

	/**
	* Adds all the elements in the given collection to this collection.
	* @param list the collection of elements to add
	*/
	Def RemoveAll(elements: Collection<T>): Unit =
		for(val e in elements)
			Remove(e)

	/**
	* Returns true if the collection contains all of the given element.
	* @param elements the collection of elements to check
	* @return		 true if the collection contains all of the given element;
					 false otherwise
	*/
	Def ContainsAll(elements: Collection<T>): Bool =
		for(val e in elements)
			if(!Contains(e))
				return false
		true

	/**
	* Returns an array containing all the elements of this collection.
	* Changing the array does not change the original collection.
	* @return an array containing all the elements of this collection
	*/
	Def ToArray(): T[] =
		val data = new T[Size()]
		var i = 0
		for(val e in this)
			data[i++] = e

		data

	/**
	* Constructs a string representation of this collection using the given
	* delimiter to seperate the elements.
	*
	* Example:
	* val c: Collection<Int> = {1, 2, 3}
	* c.MakeString("<->") // res: "1 <-> 2 <-> 3"
	*
	* @param delimiter a string to use to delimite the elements
	* @return		  a string representation of this collection using the
	*				  given delimiter to seperate the elements
	*/
	Def MakeString(delimiter: String): String =
		var s = ""
		val it = Iterator()
		while(it.HasNext())
			s += it.Next()
			if(it.HasNext())
				s += delimiter
		s

	/**
	* Returns a string representation of this collection.
	*
	* Example:
	* A collection, containing the the elements 1, 2 and 3 yields:
	* [ 1, 2, 3 ]
	*
	* @return		  a string representation of this collection
	*/
	Def toString(): String = IsEmpty() ? "[]" : "[ " + MakeString(", ") + " ]"

	//------------------------------------------------------------
	// Operators
	//------------------------------------------------------------

	/**
	* Returns true if the collections contain the same amount of elements
	* and each element of 'lhs' is contained within 'rhs' and each element
	* of 'rhs' contained in 'lhs'.
	*
	* @param lhs the lefthand side of the comparison
	* @param rhs the righthand side of the comparison
	* @return	true if the collections are equal; false otherwise
	*/
	Def ==(lhs: Collection<T>, rhs: Collection<T>): Bool =
		if(lhs.Size() != rhs.Size())
			return false

		lhs.ContainsAll(rhs) && rhs.ContainsAll(lhs)

	/**
	* Returns true if the collections contain a different amount of elements
	* or any element of the collections are not equal.
	* @param lhs the lefthand side of the comparison
	* @param rhs the righthand side of the comparison
	* @return	true if the collections are not equal; false otherwise
	*/
	Def !=(lhs: Collection<T>, rhs: Collection<T>): Bool = !(lhs == rhs)

	/**
	* Returns a hashcode for the given collection.
	* @param elements the collections to calculate a hashcode for
	* @return		 a hashcode for the given collection
	*/
	Def #(elements: Collection<T>): Int =
		var res = 0
		for(val e in elements)
			res = 31 * res ^ #e

		res
