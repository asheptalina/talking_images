import SwiftUI

struct AlertView: View {

    var title = ""
    var actions: [AlertAction] = []

    var body: some View {
        alertView()
    }

    private func alertView() -> some View {
        return VStack {
            Text(self.title)
                .foregroundColor(.white)
                .customFont(.semiBold, .medium)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            ForEach(self.actions, id: \.self) { action in
                Button(action: action.action) {
                    Text(action.label)
                        .foregroundColor(.white)
                        .customFont(.semiBold, .medium)
                }
            }
        }.background(
            RoundedRectangle(cornerRadius: 16.0)
                .fill(BACKGROUND_COLOR)
        )

    }
}

struct AlertAction: Equatable, Hashable {

    var label: String
    var action: () -> Void
    var isCancel = false

    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.label == rhs.label && lhs.isCancel == rhs.isCancel
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.label)
        hasher.combine(self.isCancel)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
