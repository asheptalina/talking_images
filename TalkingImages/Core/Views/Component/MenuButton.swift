import SwiftUI

struct MenuButton: View {

    var imageName: String
    var color: Color
    var isActive: Bool
    var itemIndex: Int
    var itemWidth: CGFloat

    var action: () -> Void

    var width: CGFloat {
        self.itemWidth * CGFloat(self.itemIndex)
    }

    var height: CGFloat {
        self.isActive ? self.activeHeightCoef * self.itemWidth : self.inactiveHeightCoef * self.itemWidth
    }

    //  UI constants
    private let cornerRadius = 32.0
    private let activeHeightCoef = 0.86
    private let inactiveHeightCoef = 0.78
    private let iconWidthCoef = 0.4

    var body: some View {
        Button {
            self.action()
        } label: {
            HStack(spacing: 0) {
                Spacer()
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(self.isActive ? ACTIVE_MENU_ITEM_COLOR : INACTIVE_MENU_ITEM_COLOR)
                    .frame(maxWidth: self.iconWidthCoef * self.itemWidth)
                    .padding(.trailing, (1 - self.iconWidthCoef) * self.itemWidth / 2)
            }
        }
        .frame(width: self.width, height: self.height)
        .background(self.color)
        .cornerRadius(self.cornerRadius, corners: .topRight)
    }

}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(imageName: MENU_EDIT, color: .blue, isActive: true, itemIndex: 1, itemWidth: 100, action: {})
    }
}
