// Created on 22/02/2020

import Foundation
import AppServices

public class SecondsRepository {
    
    public typealias HandlerCallback = (SecondsResponse) -> Void
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let dateFormatters = DateFormatCacheManager.shared
    let userDefaults = UserDefaultsManager()
    
    public init() {

    }
    
    public func sendTime(_ date: Date, handler: @escaping HandlerCallback) {
        let hour = dateFormatters.fullHourFormat.string(from: date)
        var storedDates: [String] = userDefaults.get(.hour) ?? []
        
        guard !storedDates.contains(hour) else {
            print("Not sending again \(hour)")
            return
        }
        
        storedDates.append(hour)
        userDefaults.set(storedDates, for: .hour)
        
        let seconds = dateFormatters.secondsFormat.string(from: date)
        queueOperation(hour: hour, seconds: seconds, handler: handler)
    }
    
    func queueOperation(hour: String, seconds: String, handler: @escaping HandlerCallback) {
        let request = SecondsRequest(seconds: seconds)
        
        let operation = RequestOperation(route: EndpointsRouter.seconds, requestModel: request, success: { [userDefaults] (data) in
            var storedDates: [String] = userDefaults.get(.hour) ?? []
            storedDates.removeAll(where: { $0 == hour })
            userDefaults.set(storedDates, for: .hour)
            
            do {
                let result = try JSONDecoder().decode(SecondsResponse.self, from: data)
                handler(result)
            } catch {
                print("Error while decoding \(hour): \(error)")
            }
        }, fail: { (error) in
            print("Error while sending \(hour): \(String(describing: error))")
        })
        
        queue.addOperations([operation], waitUntilFinished: false)
    }
    
}
