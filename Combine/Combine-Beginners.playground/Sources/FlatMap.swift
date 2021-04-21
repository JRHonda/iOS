import Foundation
import Combine

public class FlatMap {
    
    var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    // MARK: - Basic flatMap operations to show how flatMap "flattens"
    
    public func singleFlatMapOperation() {
        
        print("\n-- Example of a single flatMap operation --\n")
        
        let twoDegreeArray: [[Int]] = [[1, 2], [3, 4]]
        
        twoDegreeArray.publisher
            .flatMap({ return $0.publisher })
            // flatMap operation combines the inner arrays of integers producing a one degree array
            // each element in the array is then published to the sink operator
            .sink { print("Integer: \($0)")}
            .store(in: &subscriptions)
    }
    
    public func singleFlatMapOperationOn3rdDegreeArray() {
        
        print("\n-- Example of single flatMap operation on 3rd degree array [[[Int]]] --\n")
        
        /* For context to show what a (n)DegreeArray is
         let oneDegreeArray: [Int] = [1, 2, 3, 4]
         let twoDegreeArray: [[Int]] = [[1, 2], [3, 4]]
         */
        
        let threeDegreeArray: [[[Int]]] = [[[1, 2], [3, 4]]]
        
        threeDegreeArray.publisher
            .flatMap { array in
                return array.publisher
            }
            // First flatMap operator will 'flatten' the array by 1 degree
            // resulting in [[1, 2], [3, 4]]
            .sink(receiveValue: { array in
                print("Flattened result: \(array)")
                
            })
            .store(in: &subscriptions)
        
    }
    
    public func multipleFlatMapOperations() {
        
        print("\n-- Example of multiple flatMap operations --\n")
        
        /* For context to show what a (n)DegreeArray is
         let oneDegreeArray: [Int] = [1, 2, 3, 4]
         let twoDegreeArray: [[Int]] = [[1, 2], [3, 4]]
         */
        
        let threeDegreeArray: [[[Int]]] = [[[1, 2], [3, 4]]]
        
        threeDegreeArray.publisher
            .flatMap { array in
                return array.publisher
            }
            // First flatMap operator will 'flatten' the array by 1 degree
            // resulting in [[1, 2], [3, 4]]
            .flatMap { array in
                return array.publisher
            }
            // Second flatMap operator will 'flatten' the published array from
            // the first flatMap operation resulting in [1, 2, 3, 4]
            .sink(receiveValue: { array in
                
                // Since our initial publishers data is embedded 3 arrays deep,
                // the second flatMap operation will publish each Int into the
                // sink operator. This is because it takes 2 flatMap operations to reach a 1st degree array, from
                // a 3 degree array. If we were to only perform a single flatMap operation,
                // the results printed to the console would be of each individual array holding
                // the integers. -> "[1, 2]" then "[3, 4]"
                print("Flattened result: \(array)")
                
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Slightly more advanced flatMap scenarios
    
    public func flatMapUrlToReturnADataTaskPublisher() {
        
        print("\n-- Example of flatMap operation returning a DataTaskPublisher --\n")
        
        let urlSubject = PassthroughSubject<URL, Error>()
        
        urlSubject.flatMap( { requestUrl in
            return URLSession.shared.dataTaskPublisher(for: requestUrl)
                .retry(3)
                .mapError { (error) -> Error in
                    return error
                }
        })
        .map { return $0.data }
        .catch({ (error) -> Just<Data> in
            return Just(Data())
        })
        .decode(type: SwapiPerson.self, decoder: CombineDecoder().swapi)
        
//        .map { data, urlResponse in
//            return (data, urlResponse)
//        }
//        .catch( { error -> Just<(Data, URLResponse)> in
//            return Just(error)
//        })
        .sink(receiveCompletion: { print("Receieved completion:  \($0) \n")},
              receiveValue: { print("Received response string: \n\n \($0) \n")})
        .store(in: &subscriptions)
        
        urlSubject.send(URL(string: "https://swapi.dev/api/people/1")!) // Luke Skywalker
        urlSubject.send(completion: .finished)
    }
    
}
