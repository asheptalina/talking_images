import SwiftUI

enum BalooBhaijaan2: String {
    case bold = "BalooBhaijaan2-Bold"
    case extraBold = "BalooBhaijaan2-ExtraBold"
    case semiBold = "BalooBhaijaan2-SemiBold"
    case regular = "BalooBhaijaan2-Regular"
    case medium = "BalooBhaijaan2-Medium"
}

extension ContentSizeCategory {
    var size: CGFloat {
        switch self {
        case .small:
            return 20
        case .medium:
            return 24
        case .large:
            return 36
        default:
            return 24
        }
    }
}


extension Text {
    func customFont(_ font: BalooBhaijaan2, _ sizeCategory: ContentSizeCategory, color: Color = .black) -> some View {
        return self.customFont(font, sizeCategory.size, color: color)
    }
    
    func customFont(_ font: BalooBhaijaan2, _ size: CGFloat, color: Color = .black) -> some View {
        return self.font(.custom(font.rawValue, size: size))
            .foregroundColor(color)
    }
}

