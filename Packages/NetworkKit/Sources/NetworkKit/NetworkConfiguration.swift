import Foundation

public struct NetworkConfiguration {
    public let loggingEnabled: Bool
    public let timeoutInterval: TimeInterval

    public init(loggingEnabled: Bool = false, timeoutInterval: TimeInterval = 30) {
        self.loggingEnabled = loggingEnabled
        self.timeoutInterval = timeoutInterval
    }

    public static let `default` = NetworkConfiguration()
    public static let debug    = NetworkConfiguration(loggingEnabled: true)
}
