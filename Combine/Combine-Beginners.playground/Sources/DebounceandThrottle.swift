import Combine
import SwiftUI
import PlaygroundSupport

public class DebounceAndThrottle {
    
    var subscriptions = Set<AnyCancellable>()
    
    public init() {}
    
    public func debounceExample() {
        
        let bounces: [(Int, TimeInterval)] = [
            (0, 0),
            (1, 0.25),  // 0.25s interval since last index
            (2, 1),     // 0.75s interval since last index
            (3, 1.25),  // 0.25s interval since last index
            (4, 1.5),   // 0.25s interval since last index
            (5, 2)      // 0.50s interval since last index
        ]
        
        let subject = PassthroughSubject<Int, Never>()
        
        subject
            .print()
            // values that are published in intervals faster in 0.5s are simply discarded
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { value in
                print ("Processed value \(value)")
            }
            .store(in: &subscriptions)
        

        for bounce in bounces {
            DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
                subject.send(bounce.0)
            }
        }
        
        
    }
    
    public func debounceExampleTwo(on queue: DispatchQueue) {
        
        let subject = PassthroughSubject<String, Never>()
        
        subject
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .sink { print("Sink: \($0) on thread -> \(Thread.current)") }
            .store(in: &subscriptions)
            
        subject.send("Hey there!")
        
        subject.send(completion: .finished)
    }
    
}




