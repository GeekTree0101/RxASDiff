# RxASDiff

[![CI Status](https://img.shields.io/travis/Geektree0101/RxASDiff.svg?style=flat)](https://travis-ci.org/Geektree0101/RxASDiff)
[![Version](https://img.shields.io/cocoapods/v/RxASDiff.svg?style=flat)](https://cocoapods.org/pods/RxASDiff)
[![License](https://img.shields.io/cocoapods/l/RxASDiff.svg?style=flat)](https://cocoapods.org/pods/RxASDiff)
[![Platform](https://img.shields.io/cocoapods/p/RxASDiff.svg?style=flat)](https://cocoapods.org/pods/RxASDiff)


![alt text](https://github.com/GeekTree0101/RxASDiff/blob/master/resource/banner.png)
**RxASDiff** is Texture Reactive Diff Library built on DeepDiff(ref: https://github.com/onmyway133/DeepDiff)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### create diff output
```swift

let relay = BehaviorRelay<[HashableObject]>(value: [])
// Behavior or Publich or etc all Observer available

DiffObserver<HashableObject>.rxDiff(relay.asObservable()).subscribe( ... ).disposed(by: ...)
// output: Array<Change<HashableObject>> ref: https://github.com/onmyway133/DeepDiff

```

### convert diff to indexPaths object
```swift

let relay = BehaviorRelay<[HashableObject]>(value: [])
// Behavior or Publich or etc all Observer available

DiffObserver<HashableObject>.rxDiff(relay.asObservable(), section: Int).subscribe().disposed()
// output: ChangeWithIndexPath ref: https://github.com/onmyway133/DeepDiff

```

### convenience apply diff output onto tableNode or collectionNode
```swift
    func case1() {
        DiffObserver<TestModel>
            .rxDiff(relay.asObservable(), section: 1)
            .subscribe(onNext: { iter in
                self.tableNode.applyDiff(iter, completion: nil)
            }).disposed(by: bag)
    }
    
    func case2() {
        let diffObserver = DiffObserver<TestModel>.rxDiff(relay.asObservable())
        tableNode.rx
            .applyDiff(diffObserver, section: 1, completion: nil)
            .disposed(by: bag)
    }
```

## Requirements

- Xcode <~ 9.3
- Swift <~ 4.1
- iOS <~ 9.3

## Installation

RxASDiff is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxASDiff'
```

## Author

Geektree0101, h2s1880@gmail.com

## License

RxASDiff is available under the MIT license. See the LICENSE file for more info.
