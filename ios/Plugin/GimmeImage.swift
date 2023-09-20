import Foundation

@objc public class GimmeImage: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
