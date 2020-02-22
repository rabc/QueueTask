// Created on 22/02/2020

import Foundation

public struct DateFormatCacheManager {
    
    public static let shared = DateFormatCacheManager()
    
    public let fullHourFormat: DateFormatter
    public let secondsFormat: DateFormatter
    
    public init() {
        self.fullHourFormat = DateFormatter()
        self.fullHourFormat.dateFormat = "HH:mm:ss"
        
        self.secondsFormat = DateFormatter()
        self.secondsFormat.dateFormat = "ss"
    }
}
