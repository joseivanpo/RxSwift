/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxSwift-OSX** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 [Previous](@previous) - [Table of Contents](Table_of_Contents)
 */
import RxSwift
/*:
 # Working with Subjects
 A Subject is a sort of bridge or proxy that is available in some implementations of Rx that acts as both an observer and `Observable`. Because it is an observer, it can subscribe to one or more `Observable`s, and because it is an `Observable`, it can pass through the items it observes by reemitting them, and it can also emit new items. [More info](http://reactivex.io/documentation/subject.html)
*/
extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(_ id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }
    
}

func writeSequenceToConsole<O: ObservableType>(name: String, sequence: O) -> Disposable {
    return sequence.subscribe { event in
        print("Subscription: \(name), event: \(event)")
    }
}
/*:
 ## PublishSubject
 Broadcasts new events to all observers as of their time of the subscription.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png "PublishSubject")
 */
example("PublishSubject") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    
    subject.addObserver("1").addDisposableTo(disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").addDisposableTo(disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
 > This example also introduces using the `onNext(_:)` convenience method, equivalent to `on(.Next(_:)`, which causes a new Next event to be emitted to subscribers with the provided `element`. There are also `onError(_:)` and `onCompleted()` convenience methods, equivalent to `on(.Error(_:))` and `on(.Completed)`, respectively.
 ----
 ## ReplaySubject
 Broadcasts new events to all subscribers, and the specified `bufferSize` number of previous events to new subscribers.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)
*/
example("ReplaySubject") {
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    subject.addObserver("1").addDisposableTo(disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").addDisposableTo(disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
 ----
## BehaviorSubject
Broadcasts new events to all subscribers, and the most recent (or initial) value to new subscribers.
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png)
*/
example("BehaviorSubject") {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "🔴")
    
    subject.addObserver("1").addDisposableTo(disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").addDisposableTo(disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    subject.addObserver("3").addDisposableTo(disposeBag)
    subject.onNext("🍐")
    subject.onNext("🍊")
}
/*:
 > Notice what's missing in these previous examples? A Completed event. `PublishSubject`, `ReplaySubject`, and `BehaviorSubject` do not automatically emit Completed events when they are about to be disposed of.
 ----
 ## Variable
 Wraps a `BehaviorSubject`, so it will emit the most recent (or initial) value to new subscribers. And `Variable` also maintains current value state. `Variable` will never emit an Error event. However, it will automatically emit a Completed event and terminate on `deinit`.
*/
example("Variable") {
    let disposeBag = DisposeBag()
    let variable = Variable("🔴")
    
    variable.asObservable().addObserver("1").addDisposableTo(disposeBag)
    variable.value = "🐶"
    variable.value = "🐱"
    
    variable.asObservable().addObserver("2").addDisposableTo(disposeBag)
    variable.value = "🅰️"
    variable.value = "🅱️"
}
//:  > Call `asObservable()` on a `Variable` instance in order to access its underlying `BehaviorSubject` sequence. `Variable`s do not implement the `on` operator (or, e.g., `onNext(_:)`), but instead expose a `value` property that can be used to get the current value, and also set a new value. Setting a new value will also add that value onto its underlying `BehaviorSubject` sequence.

//: [Next](@next) - [Table of Contents](Table_of_Contents)