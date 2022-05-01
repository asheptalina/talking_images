import SwiftUI

struct SetPointsView: View {

    @EnvironmentObject var store: AppStore

    @State private var pointyEars = false

    private let title = "You can set the points manually"

    // UI constants
    private let titlePaddingTopCoef = 0.09
    private let horizontalSpacingCoef = 0.07

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Image(uiImage: self.store.state.imageState.processedImage!)
                        .resizable()
                        .scaledToFit()
                    Contours(
                        pointyEars: self.pointyEars,
                        head1Position: self.store.state.pointsState.head1Position,
                        head2Position: self.store.state.pointsState.head2Position,
                        head3Position: self.store.state.pointsState.head3Position,
                        eye1Position: self.store.state.pointsState.eye1Position,
                        eye2Position: self.store.state.pointsState.eye2Position,
                        mouth1Position: self.store.state.pointsState.mouth1Position,
                        mouth2Position: self.store.state.pointsState.mouth2Position,
                        mouth3Position: self.store.state.pointsState.mouth3Position,
                        chinPosition: self.store.state.pointsState.chinPosition,
                        ear1Position: self.store.state.pointsState.ear1Position,
                        ear2Position: self.store.state.pointsState.ear2Position
                    ).stroke(.white, style: StrokeStyle(lineWidth: 2.0))

                    self.points()
                }.frame(width: geometry.size.width, height: geometry.size.width)

                Text(self.title)
                    .customFont(.semiBold, .medium, color: TEXT_COLOR)
                    .padding(.top, geometry.size.width * self.titlePaddingTopCoef)
                HStack {
                    Text("Pointy ears")
                        .customFont(.semiBold, .medium, color: TEXT_COLOR)
                    Toggle(isOn: self.$pointyEars, label: {})
                        .tint(ALERT_COLOR)
                    Spacer()
                }.padding(.horizontal,  geometry.size.width * self.horizontalSpacingCoef)
            }.onAppear {
                if !self.store.state.pointsState.pointsAreSetted {
                    self.store.send(.poins(action: .setDefaultPoins(width: geometry.size.width)))
                }
                self.pointyEars = self.store.state.pointsState.pointyEars
            }
            .onChange(of: self.pointyEars) { newValue in
                self.store.send(.poins(action: .setPointyEars(self.pointyEars)))
            }
        }
    }

    private func points() -> some View {
        return ZStack {
            PointView(
                title: "head",
                position: self.store.state.pointsState.head1Position
            ) { point in
                self.store.send(.poins(action: .setHead1Position(newPosition: point)))
            }
            PointView(
                title: "head",
                position: self.store.state.pointsState.head2Position
            ) { point in
                self.store.send(.poins(action: .setHead2Position(newPosition: point)))
            }
            PointView(
                title: "head",
                position: self.store.state.pointsState.head3Position
            ) { point in
                self.store.send(.poins(action: .setHead3Position(newPosition: point)))
            }
            PointView(
                title: "eye",
                position: self.store.state.pointsState.eye1Position
            ) { point in
                self.store.send(.poins(action: .setEye1Position(newPosition: point)))
            }
            PointView(
                title: "eye",
                position: self.store.state.pointsState.eye2Position
            ) { point in
                self.store.send(.poins(action: .setEye2Position(newPosition: point)))
            }
            PointView(
                title: "mouth",
                position: self.store.state.pointsState.mouth1Position
            ) { point in
                self.store.send(.poins(action: .setMouth1Position(newPosition: point)))
            }
            PointView(
                title: "mouth",
                position: self.store.state.pointsState.mouth2Position
            ) { point in
                self.store.send(.poins(action: .setMouth2Position(newPosition: point)))
            }
            PointView(
                title: "mouth",
                position: self.store.state.pointsState.mouth3Position
            ) { point in
                self.store.send(.poins(action: .setMouth3Position(newPosition: point)))
            }
            PointView(
                title: "chin",
                position: self.store.state.pointsState.chinPosition
            ) { point in
                self.store.send(.poins(action: .setChinPosition(newPosition: point)))
            }
            if self.pointyEars {
                PointView(
                    title: "ear",
                    position: self.store.state.pointsState.ear1Position
                ) { point in
                    self.store.send(.poins(action: .setEar1Position(newPosition: point)))
                }
                PointView(
                    title: "ear",
                    position: self.store.state.pointsState.ear2Position
                ) { point in
                    self.store.send(.poins(action: .setEar2Position(newPosition: point)))
                }
            }
        }
    }
}

struct PointView: View {

    var title: String

    var position: CGPoint

    var onChangePosition: (CGPoint) -> Void
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        VStack {
//            Text(title)
//                .customFont(.semiBold, .small, color: LIGHT_TEXT_COLOR)
//                .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
//                .position(x: position.x + 12, y: position.y)
            Circle()
                .strokeBorder(LIGHT_TEXT_COLOR, lineWidth: 3)
                .background(Circle().foregroundColor(TEXT_COLOR))
                .frame(width: 12, height: 12)
                .position(x: position.x, y: position.y)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            self.onChangePosition(CGPoint(x: value.location.x, y: value.location.y))
                        })
                )
        }
    }
}

struct SetPointsView_Previews: PreviewProvider {
    static var previews: some View {
        SetPointsView()
    }
}
