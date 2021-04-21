import Combine
import Foundation

public class Map {
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() {}
    
    ///
    public func mapArrayOfIntegerStringsToIntegers() {
        
        print("\n-- Example of basic Combine map() operator --\n")
        
        let arrayOfStrings = ["1", "2", "3"]
        
        arrayOfStrings.publisher
            .map { (string) -> Int in
                return Int(string) ?? 0
            }
            .sink(receiveValue: { print("Transformed string: \($0)")} )
            .store(in: &subscriptions)
    }
    
    ///
    public func mapUsingKeyPath() {
        
        print("\n-- Example of map(keyPath: KeyPath<(Double, Double), T>) --\n")
        
        let arrayOfDoubles: [(Double, Double)] = [(1.0, 2), (2.0, 4), (3.0, 6)]
        
        arrayOfDoubles.publisher
            .map({ return Multiple(value: $0.0, factor: $0.1) })
            .map(\.result) // 'result' KeyPath of Multiple instance
            .sink { (result) in
                print("The result of the multiplication is: \(result)")
            }
            .store(in: &subscriptions)
        
        // Another for fun
        Just(Multiple(value: 3, factor: 4))
            .map(\.result)
            .sink(receiveValue: { print("From a Just publisher, the result is: \($0)") })
            .store(in: &subscriptions)
    }
    
    public func mapUsingMultipleKeyPaths() {
        
        print("\n-- Example of map(_ keyPath1, _ keyPath2, _ kayPath3) --\n")
        
        Just(Multiple(value: 5, factor: 6))
            .map(\.factor, \.value, \.result)
            .sink { (keyPaths) in
                print("\(keyPaths.0) * \(keyPaths.1) == \(keyPaths.2)")
            }
            .store(in: &subscriptions)
    }
    
    ///
    public func mapErrorExample() {
        
        print("\n -- Example of mapError when division by zero occurs --\n")
        
        struct DivideByZeroError: Error { }
        struct GenericError: Error { var wrappedError: Error }
        
        func divide<T: Numeric & FloatingPoint>(_ a: T, _ b: T) throws -> T {
            guard b != 0 else {throw DivideByZeroError() }
            return a / b
        }
        
        let numArray = [3.0, 2.0, 1.0, 0]
        
        numArray.publisher
            .tryMap({ return try divide(1, $0) })
            .mapError( { GenericError(wrappedError: $0) } )
            .sink(receiveCompletion: { print("Completion: \($0)")},
                  receiveValue: { print("Received: \($0)")})
            .store(in: &subscriptions)
    }
    
}
