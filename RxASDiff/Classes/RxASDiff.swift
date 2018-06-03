//
//  RxASDiff.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation
import RxSwift
import RxCocoa
import DeepDiff

public class ASDiffRelay<T: Hashable> {
    private var internalBehaviorlRelay: BehaviorRelay<[T]>
    let skipCount: Int
    
    public var value: [T] {
        return internalBehaviorlRelay.value
    }
    
    public init(_ initial: [T], skip: Int) {
        self.skipCount = skip
        self.internalBehaviorlRelay = .init(value: initial)
    }
    
    public func rxDiff(_ seed: [T] = [],
                       _ diffSeed: [Change<T>] = []) -> Observable<([Change<T>], Int)> {
        return internalBehaviorlRelay
            .scan((seed, diffSeed),
                  accumulator: { source, new -> (new: [T], diff: [Change<T>]) in
                    let old = source.0
                    return (new: new, diff: diff(old: old, new: new))
            }).map { new, diff -> ([Change<T>], Int) in
                return (diff, new.count)
            }.asObservable()
    }
    
    public func rxDiff(_ seed: [T] = [],
                       _ diffSeed: [Change<T>] = [],
                       section: Int) -> Observable<(ChangeWithIndexPath, Int)> {
        return self.rxDiff(seed, diffSeed)
            .map { (IndexPathConverter().convert(changes: $0.0, section: section), $0.1) }
            .observeOn(MainScheduler.asyncInstance)
    }
    
    public func append(_ array: [T]) {
        internalBehaviorlRelay.accept(internalBehaviorlRelay.value + array)
    }
    
    public func prepend(_ array: [T]) {
        internalBehaviorlRelay.accept(array + internalBehaviorlRelay.value)
    }
    
    @discardableResult public func remove(_ object: T) -> T? {
        var value = internalBehaviorlRelay.value
        guard let index = value.index(of: object) else { return nil }
        let removedItem = value.remove(at: index)
        internalBehaviorlRelay.accept(value)
        return removedItem
    }
    
    public func insert(_ item: T, at: Int) {
        var value = internalBehaviorlRelay.value
        value.insert(item, at: at)
        internalBehaviorlRelay.accept(value)
    }
    
    public func replace(_ source: Int, _ target: Int) {
        var value = internalBehaviorlRelay.value
        value.swapAt(source, target)
        internalBehaviorlRelay.accept(value)
    }
}
