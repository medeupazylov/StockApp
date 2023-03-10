import UIKit

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
