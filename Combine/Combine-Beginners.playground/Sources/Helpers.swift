import Foundation

public struct Helpers {
    
    public static func example(of code: String, action: () -> Void) {
        print("---- Example of: \(code) ----")
        action()
    }
    
}


