// Created on 22/02/2020

import Foundation

public struct SecondsResponse: Decodable {
    public let id: Int
    public let seconds: String
}

public struct SecondsRequest: Encodable {
    public let seconds: String
    
    public init(seconds: String) {
        self.seconds = seconds
    }
}
