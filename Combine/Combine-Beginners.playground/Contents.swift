import UIKit
import Combine

let dg = DispatchGroup()
let semaphore = DispatchSemaphore(value: 0)
let mainExecutionQueue = DispatchQueue(label: "main exec queue")

let map = Map(semaphore: semaphore)
let mapWorkItem = DispatchWorkItem {
    map.mapArrayOfIntegerStringsToIntegers()
    map.mapUsingKeyPath()
    map.mapUsingMultipleKeyPaths()
    map.mapErrorExample()
    map.exampleImplementationOfVerbosityUsingMapInsteadOfFlatMap()
}

let flatMap = FlatMap(semaphore: semaphore)
let flatMapWorkItem = DispatchWorkItem {
    flatMap.singleFlatMapOperation()
    flatMap.singleFlatMapOperationOn3rdDegreeArray()
    flatMap.multipleFlatMapOperations()
    flatMap.flatMapUrlToReturnADataTaskPublisher()
}

mainExecutionQueue.async(group: dg) {
    
    let timeout = DispatchTime.now() + .seconds(5)
    
    print("\n** map() DispatchWorkItem has started **\n")
    dg.enter()
    mapWorkItem.perform()
    semaphore.wait(timeout: timeout)
    dg.leave()
    print("\n** map() DispatchWorkItem has completed **\n")
    
    print("\n** flatMap() DispatchWorkItem has started **\n")
    dg.enter()
    flatMapWorkItem.perform()
    semaphore.wait(timeout: timeout)
    dg.leave()
    print("\n** flatMap() DispatchWorkItem has completed **\n")
    
}
