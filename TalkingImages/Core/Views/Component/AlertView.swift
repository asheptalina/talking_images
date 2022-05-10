import SwiftUI

struct AlertView: View {

    var title = ""
    var actions: [AlertAction] = []

    // UI constants
    private let horizontalOuterPaddingCoef = 0.07
    private let alertInternalPaddingCoef = 0.07
    private let alertRadiusCoef = 0.03
    private let buttonHorizontalPaddingCoef = 0.07
    private let buttonVerticalPaddingCoef = 0.03
    private let buttonRadiusCoef = 0.02

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        self.alertView(width: geometry.size.width)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    private func alertView(width: CGFloat) -> some View {
        return VStack(spacing: width * self.alertInternalPaddingCoef) {
            Text(self.title)
                .customFont(.semiBold, .medium, color: TEXT_COLOR)
                .multilineTextAlignment(.center)
            HStack {
                ForEach(self.actions, id: \.self) { action in
                    Button(action: action.action) {
                        Text(action.label)
                            .customFont(.semiBold, .medium, color: action.isCancel ? ALERT_COLOR : .white)
                            .padding(.horizontal, width * self.buttonHorizontalPaddingCoef)
                            .padding(.vertical, width * self.buttonVerticalPaddingCoef)
                            .background(
                                RoundedRectangle(cornerRadius: width * self.buttonRadiusCoef)
                                    .fill(ALERT_COLOR.opacity(action.isCancel ? 0 : 1))
                            )
                            .background(
                                RoundedRectangle(cornerRadius: width * self.buttonRadiusCoef)
                                    .stroke(
                                        ALERT_COLOR.opacity(action.isCancel ? 1 : 0),
                                        style: StrokeStyle(lineWidth: 3)
                                    )
                            )
                    }
                }
            }
        }
        .padding(.all, width * self.alertInternalPaddingCoef)
        .background(
            RoundedRectangle(cornerRadius: width * self.alertRadiusCoef)
                .fill(BACKGROUND_COLOR)
        )
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
