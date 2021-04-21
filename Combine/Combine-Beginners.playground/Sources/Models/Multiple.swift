import Foundation

struct Multiple<T : Numeric> {
    
    public let value: T
    public let factor: T
    
    public var result: T {
        get {
            return value * factor
        }
    }
}
