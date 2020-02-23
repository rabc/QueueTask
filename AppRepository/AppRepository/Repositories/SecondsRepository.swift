// Created on 22/02/2020

import Foundation
import AppServices

struct HourData: Codable {
    let seconds: String
    let hour: String
    var sent: Bool = false
}

public class SecondsRepository {
    
    public typealias HandlerCallback = (SecondsResponse) -> Void
    
    public static let shared = SecondsRepository()
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let dispatch = DispatchQueue(label: "seconds.dispatch.queue")
    
    let dateFormatters = DateFormatCacheManager.shared
    let userDefaults = UserDefaultsManager()
    
    public init() {

    }
    
    public func sendTime(_ date: Date, handler: @escaping HandlerCallback) {
        let hour = dateFormatters.fullHourFormat.string(from: date)
        let seconds = dateFormatters.secondsFormat.string(from: date)
        
        dispatch.sync {
            var storedDates: [HourData] = userDefaults.get(.hour) ?? []
            
            if let currentDate = storedDates.first(where: { $0.hour == hour}) {
                if currentDate.sent || queue.hasOperation(name: currentDate.hour) {
                    print("Not sending again \(currentDate.hour)")
                    return
                }
            }
            
            storedDates.append(HourData(seconds: seconds, hour: hour))
            userDefaults.set(storedDates, for: .hour)
            queueOperation(name: hour, hour: hour, seconds: seconds, handler: handler)
        }
    }
    
    private func queueOperation(name: String, hour: String, seconds: String, handler: @escaping HandlerCallback) {
        let request = SecondsRequest(seconds: seconds)
        
        let operation = RequestOperation(name: name, route: EndpointsRouter.seconds, requestModel: request, success: { [userDefaults] (data) in
            
            var storedDates: [HourData] = userDefaults.get(.hour) ?? []
            if let currentDateIdx = storedDates.firstIndex(where: { $0.hour == hour}) {
                storedDates[currentDateIdx].sent = true
                userDefaults.set(storedDates, for: .hour)
            }
            
            do {
                let result = try JSONDecoder().decode(SecondsResponse.self, from: data)
                handler(result)
            } catch {
                print("Error while decoding \(hour): \(error)")
            }
        }, fail: { (error) in
            print("Error while sending \(hour): \(String(describing: error))")
        })
        
        print("Queue [\(hour)]")
        queue.addOperations([operation], waitUntilFinished: false)
    }
    
    public func flush() {
        let storedDates: [HourData] = userDefaults.get(.hour) ?? []
        
        storedDates
            .filter { !$0.sent && !queue.hasOperation(name: $0.hour) }
            .forEach {
                queueOperation(name: $0.hour, hour: $0.hour, seconds: $0.seconds) {
                    print("Flushed \($0.seconds) with id \($0.id)")
                }
        }
    }
    
}

extension OperationQueue {
    func hasOperation(name: String) -> Bool {
        return operations.contains(where: { $0.name == name })
    }
}
