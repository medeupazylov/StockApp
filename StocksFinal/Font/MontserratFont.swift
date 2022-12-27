import CoreGraphics
import UIKit
enum MontserratFontType {
    case regular
    case bold
    case semibold
}

class MontserratFont {
    static func makefont(name: MontserratFontType, size: CGFloat)  -> UIFont {
        switch name {
        case .regular:
            return UIFont(name: "Montserrat", size: size)!
        case .bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
        case .semibold:
            return UIFont(name: "Montserrat-SemiBold", size: size)!
        }
    }
}
