import Foundation

public class CombineDecoder {
    
}

public extension CombineDecoder {
    
    final var swapi: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXX"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
}
