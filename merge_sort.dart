enum MergeAlgorithm { mergeList, mergeIterable }

/// O(n log n) or quasilinear
List<E> mergeSort<E extends Comparable<dynamic>>(List<E> list,
    [MergeAlgorithm mergeAlgorithm = MergeAlgorithm.mergeList]) {
  // Here you split the list into halves.
  // You need to keep splitting recursively until you can't split
  // anymore, which is when each subdivision contains just one
  // element.
  // Base case as an exit condition. The base case one element.
  if (list.length < 2) {
    print('recursion ending: $list');
    return list;
  } else {
    print('recursion list in: $list');
  }
  // You're now recursively calling mergeSort on the left and
  // right halves of the original list.
  final middle = list.length ~/ 2;

  final left = mergeSort(list.sublist(0, middle));

  final right = mergeSort(list.sublist(middle));

  // This will combine the left and right lists that you split
  // above.
  List<E> merged;
  if (mergeAlgorithm == MergeAlgorithm.mergeList) {
    merged = _mergeList(left, right);
  } else {
    // merged = _mergeIterable(left, right);
    merged = _merge3(left, right);
  }
  print('recursion ending: merging $left and $right -> $merged');
  return merged;
}

// The sole responsibility of this function is to take in two
// sorted lists and combine them while retaining the sort order.
List<E> _mergeList<E extends Comparable<dynamic>>(
    List<E> listA, List<E> listB) {
  // indexA and indexB track your progress as you parse through
  // the two lists.
  var indexA = 0;
  var indexB = 0;
  // will house the merged list
  final result = <E>[];
  // Starting from the beginning of listA and listB, you
  // sequentially compare the values. If you've reached the
  // end of either list, there's nothing else to compare.
  while (indexA < listA.length && indexB < listB.length) {
    final valueA = listA[indexA];
    final valueB = listB[indexB];
    // The smaller of the two values go into the result list.
    if (valueA.compareTo(valueB) < 0) {
      // valueA ordered before valueB
      result.add(valueA);
      indexA += 1;
    } else if (valueA.compareTo(valueB) > 0) {
      result.add(valueB);
      indexB += 1;
    } else {
      // If the values are equal, they can both be added.
      result.add(valueA);
      result.add(valueB);
      indexA += 1;
      indexB += 1;
    }
  }
  // The while loop above guaranteed that either left or right is
  // already empty.
  // Since both list are sorted, this ensures that any leftover
  // elements are greater than or equal to the ones currently in
  // result.
  if (indexA < listA.length) {
    result.addAll(listA.getRange(indexA, listA.length));
  }
  if (indexB < listB.length) {
    result.addAll(listB.getRange(indexB, listB.length));
  }
  return result;
}

List<E> _mergeIterable<E extends Comparable<dynamic>>(
    Iterable<E> first, Iterable<E> second) {
  // Create a new list to store the merged iterables.
  var result = <E>[];
  // Grab the iterators. Iterators are objects that know how to
  // get the next value in the iterable.
  var firstIterator = first.iterator;
  var secondIterator = second.iterator;
  // `moveNext` returns true if the iterator found a next element,
  // or false if the end of the collection was reached.
  var firstHasValue = firstIterator.moveNext();
  var secondHasValue = secondIterator.moveNext();
  // This proccess will continue until one of the iterators
  // runs out of values.
  while (firstHasValue && secondHasValue) {
    // Grab the values using the current property of your
    // iterators.
    final firstValue = firstIterator.current;
    final secondValue = secondIterator.current;

    //  If the first value is less than the second, you'll add
    // the first value to result and then move the iterator to
    // the next value.
    if (firstValue.compareTo(secondValue) < 0) {
      result.add(firstValue);
      firstHasValue = firstIterator.moveNext();
    }
    // else do the opposite.
    else if (firstValue.compareTo(secondValue) > 0) {
      result.add(secondValue);
      secondHasValue = secondIterator.moveNext();
    }
    // if both values are equal, you'll add them both and move
    // the iterators on.
    else {
      result.add(firstValue);
      result.add(secondValue);
      firstHasValue = firstIterator.moveNext();
      secondHasValue = secondIterator.moveNext();
    }
  }
  // If the other iterator still has any values left,
  // they'll be equal to or greather than the ones in result.
  if (firstHasValue) {
    do {
      result.add(firstIterator.current);
    } while (firstIterator.moveNext());
  }
  if (secondHasValue) {
    do {
      result.add(secondIterator.current);
    } while (secondIterator.moveNext());
  }

  return result;
}

void main() {
  final list = [4, 2, 5, 1, 3];
  final sorted = mergeSort(list, MergeAlgorithm.mergeIterable);
  print('Original: $list');
  print('Merge sorted: $sorted');
}

List<E> _merge3<E extends Comparable<dynamic>>(
    Iterable<E> first, Iterable<E> second) {
  // store iterable that know next value and has value of a collection
  final firstIterator = first.iterator;
  final secondIterator = second.iterator;
  // create result to hold results;
  final result = <E>[];
  // return true if first list has value and return false if it doesn't;
  var firstHasValue = firstIterator.moveNext();
  var secondHasValue = secondIterator.moveNext();
  // continue as long as first list and second list have values
  while (firstHasValue && secondHasValue) {
    // store current value of iterator
    final firstValue = firstIterator.current;
    final secondValue = secondIterator.current;
    // if first value is less than second value then adds it to result.
    if (firstValue.compareTo(secondValue) < 0) {
      result.add(firstValue);
      firstHasValue = firstIterator.moveNext();
      // or the opposite
    } else if (firstValue.compareTo(secondValue) > 0) {
      result.add(secondValue);
      secondHasValue = secondIterator.moveNext();
      //if both values are equal then add both of them and update hasNextValue flag
    } else {
      result.add(firstValue);
      firstHasValue = firstIterator.moveNext();
      result.add(secondValue);
      secondHasValue = secondIterator.moveNext();
    }
  }
  // if there is still value then add them and update it
  // if (firstHasValue) {
  //   // first add then update
  //   do {
  //     final firstValue = firstIterator.current;
  //     firstHasValue = firstIterator.moveNext();
  //     result.add(firstValue);
  //   } while (firstHasValue);
  // }
  // while first has value then adds them to results
  while (firstHasValue) {
    final firstValue = firstIterator.current;
    result.add(firstValue);
    firstHasValue = firstIterator.moveNext();
  }
  // same as above while
  // if do while pattern
  if (secondHasValue) {
    do {
      result.add(secondIterator.current);
      secondHasValue = secondIterator.moveNext();
    } while (secondHasValue);
  }

  return result;
}
