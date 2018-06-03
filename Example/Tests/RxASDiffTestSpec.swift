import Quick
import Nimble
import XCTest
import DeepDiff
import RxCocoa
import RxSwift
import RxTest
import AsyncDisplayKit
@testable import RxASDiff

class RxASDiffTestSpec: QuickSpec {
    override func spec() {
        describe("RxASDiff Unit Test") {
            let behaviorRelay = BehaviorRelay<[Model]>.init(value: [])
            let defaultItem: [Model] = [1, 2, 3, 4, 5].map { Model($0) }
            let appendItem: [Model] = [-5, -4, -3, -2, -1].map { Model($0) }
            let prependItem: [Model] = [6, 7, 8, 9, 10].map { Model($0) }
            let disposeBag = DisposeBag()
            
            var viewController: RxASDiffTestController!
            
            enum Scope {
                case initial([Model])
                case append([Model])
                case prepend([Model])
            }
            
            beforeEach {
                viewController = RxASDiffTestController.init()
                viewController.viewDidLoad()
                viewController.viewWillAppear(false)
                viewController.viewDidAppear(false)
            }
            
            it("should be parse change hashable item") {
                let scheduler = TestScheduler.init(initialClock: 0)
                let hotObserver = scheduler.createHotObservable([next(100, Scope.initial(defaultItem)),
                                                                 next(200, Scope.append(appendItem)),
                                                                 next(300, Scope.prepend(prependItem))])
                
                let record = scheduler.record(DiffObserver<Model>.rxDiff(behaviorRelay.asObservable()))
                
                hotObserver.subscribe(onNext: { scope in
                    switch scope {
                    case .initial(let items):
                        behaviorRelay.accept(items)
                    case .append(let items):
                        behaviorRelay.accept(behaviorRelay.value + items)
                    case .prepend(let items):
                        behaviorRelay.accept(items + behaviorRelay.value)
                    }
                }).disposed(by: disposeBag)
                
                scheduler.start()
                let outputEvent: [Recorded<Event<[Change<Model>]>>] = record.events
                
                let expectedEvent: [Recorded<Event<[Change<Model>]>>] =
                    [next(0, []),
                     next(100, diff(old: [],
                                    new: defaultItem)),
                     next(200, diff(old: defaultItem,
                                    new: defaultItem + appendItem)),
                     next(300, diff(old: defaultItem + appendItem,
                                    new: prependItem + defaultItem + appendItem))]
                
                XCTAssertEqual(outputEvent.map { $0.debugDescription },
                               expectedEvent.map { $0.debugDescription })
            }
            
            it("should be initalization view controller") {
                expect(viewController.itemBehaviorRelay.value.count)
                    .to(equal(viewController.defaultItemList.count))
                expect(viewController.tableNode.numberOfRows(inSection: 1))
                    .to(equal(viewController.defaultItemList.count))
                expect(viewController.itemBehaviorRelay.value.count)
                    .to(equal(viewController.tableNode.numberOfRows(inSection: 1)))
            }
        }
    }
    
    struct Model: Hashable {
        var hashValue: Int {
            return identifier.hashValue
        }
        
        let identifier: String
        
        init(_ num: Int) {
            self.identifier = "Model-\(num)-Identifier"
        }
    }
}

extension TestScheduler {
    /// Creates a `TestableObserver` instance which immediately subscribes
    /// to the `source` and disposes the subscription at virtual time 100000.
    func record<O: ObservableConvertibleType>(_ source: O) -> TestableObserver<O.E> {
        let observer = self.createObserver(O.E.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}
