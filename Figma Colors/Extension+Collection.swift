//
//  Extension+Array.swift
//  ITMobile
//
//  Created by Миронов Влад on 27.02.2020.
//  Copyright © 2020 Миронов Влад. All rights reserved.
//

import Foundation
extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}

extension Array {
    /// Initial array must be sorted
    func group<T: Equatable>(by key: ((Element)->(T))) -> [[Element]]{
        var groupedArray = [[Element]]()

        for i in 0..<count {
            let current = self[i]
            
            if let previus = self[safe: i - 1] {
                if key(previus) == key(current) {
                    groupedArray[groupedArray.endIndex - 1].append(current)
                } else {
                    groupedArray.append([current])
                }
            } else {
                groupedArray.append([current])
            }
        }
        return groupedArray
    }
}

extension Array where Element: RangeReplaceableCollection {

    typealias InnerCollection = Element
    typealias Item = InnerCollection.Iterator.Element
    
    mutating func append<Key: Equatable>(items: [Item], groupBy key: ((Item)->(Key))) {
        
        for i in 0..<items.count {
            let current = items[i]
            
            if let previus = (self.last as? [Item])?.last {
                if key(previus) == key(current) {
                    self[self.endIndex - 1].append(current)
                } else {
                    append([current] as! Element)
                }
            } else {
                append([current] as! Element)
            }
        }
    }
    
    ///Perfomance append 2D array
    mutating func append<Key: Equatable>(items: [Item], groupBy key: @escaping ((Item)->(Key)), setValue: @escaping (([Element])->Void)) {
        var newArray = self //as! [Element]

        DispatchQueue.global().async {
            for i in 0..<items.count {
                let current = items[i]
                
                if let previus = (newArray.last as? [Item])?.last {
                    if key(previus) == key(current) {
                        newArray[newArray.endIndex - 1].append(current)
                    } else {
                        newArray.append([current] as! Element)
                    }
                } else {
                    newArray.append([current] as! Element)
                }
            }
            DispatchQueue.main.async {
                setValue(newArray)
            }
        }
    }
    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
