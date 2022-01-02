import SwiftUI

struct MenuButton: View {
    
    var imageName: String
    var color: Color
    var isActive: Bool
    var width: CGFloat
    
    var action: () -> ()
    
    let activeHeight = 80.0
    let inactiveHeight = 72.0
    let cornerRadius = 32.0
    
    var body: some View {
        Button { 
            self.action()
        } label: { 
            HStack(spacing: 0) {
                Spacer()
                // TODO: fix size
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(self.isActive ? ACTIVE_MENU_ITEM_COLOR : INACTIVE_MENU_ITEM_COLOR)
                    .padding(EdgeInsets(top: 20.0, leading: 25.0, bottom: 20.0, trailing: 32))
            }
        }
        .frame(width: self.width, height: self.isActive ? self.activeHeight : self.inactiveHeight)
        .background(self.color)
        .cornerRadius(self.cornerRadius, corners: .topRight)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(imageName: MENU_EDIT, color: .blue, isActive: true, width: 100.0, action: {})
    }
}
