//
//  RxASDiff.swift
//
//  Created by Geektree0101 on 2018. 6. 3..
//

import Foundation
import RxSwift
import RxCocoa
import DeepDiff

public struct DiffObserver<T: Hashable> {
    public static func rxDiff(_ observer: Observable<[T]>,
                              seed: [T] = [],
                              diffSeed: [Change<T>] = []) -> Observable<[Change<T>]> {
        return observer
            .scan((seed, diffSeed),
                  accumulator: { source, new -> ([T], [Change<T>]) in
                    return (new,
                            diff(old: source.0, new: new))
            })
            .map { $0.1 }
    }
    
    public static func rxDiff(_ observer: Observable<[T]>,
                              seed: [T] = [],
                              diffSeed: [Change<T>] = [],
                              section: Int) -> Observable<ChangeWithIndexPath> {
        return observer
            .scan((seed, diffSeed),
                  accumulator: { source, new -> ([T], [Change<T>]) in
                    return (new, diff(old: source.0, new: new))
            })
            .map { $0.1 }
            .map { IndexPathConverter().convert(changes: $0, section: section) }
    }
}
