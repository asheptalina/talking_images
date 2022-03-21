import SwiftUI

//struct Contours: Shape {
//    
//    var rect: CGRect
//    
//    var head1Position: CGPoint
//    var head2Position: CGPoint
//    var head3Position: CGPoint
//    var eye1Position: CGPoint
//    var eye2Position: CGPoint
//    var mouth1Position: CGPoint
//    var mouth2Position: CGPoint
//    var mouth3Position: CGPoint
//    var chinPosition: CGPoint
//    var ear1Position: CGPoint
//    var ear2Position: CGPoint
//    
//    func path(in rect: CGRect) -> Path {
//        let path = CGMutablePath()
//        
//        path.move(to: head1Position)
//        path.addArc(tangent1End: <#T##CGPoint#>, tangent2End: <#T##CGPoint#>, radius: <#T##CGFloat#>)
//    }
//    
//}

struct SetPointsView: View {

    @EnvironmentObject var viewModel: TalkingImagesViewModel

    @State private var pointyEars = true

    private let title = "You can set the points manually"

    @State private var head1Position = CGSize(width: 30, height: 50)
    @State private var head2Position = CGSize(width: 60, height: 50)
    @State private var head3Position = CGSize(width: 45, height: 30)
    @State private var eye1Position = CGSize(width: 40, height: 50)
    @State private var eye2Position = CGSize(width: 10, height: 50)
    @State private var mouth1Position = CGSize(width: 10, height: 50)
    @State private var mouth2Position = CGSize(width: 10, height: 50)
    @State private var mouth3Position = CGSize(width: 10, height: 50)
    @State private var chinPosition = CGSize(width: 10, height: 50)
    @State private var ear1Position = CGSize(width: 10, height: 50)
    @State private var ear2Position = CGSize(width: 10, height: 50)

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    self.viewModel.image!
                        .resizable()
                        .scaledToFit()
                    PointView(title: "head", position: self.$head1Position)
                    PointView(title: "head", position: self.$head2Position)
                    PointView(title: "head", position: self.$head3Position)
                    PointView(title: "eye", position: self.$eye1Position)
                    PointView(title: "eye", position: self.$eye2Position)
                    PointView(title: "mouth", position: self.$mouth1Position)
                    PointView(title: "mouth", position: self.$mouth2Position)
                    PointView(title: "mouth", position: self.$mouth3Position)
                    PointView(title: "chin", position: self.$chinPosition)
//                    PointView(title: "ear", position: self.$ear1Position)
//                    PointView(title: "ear", position: self.$ear2Position)
                }.frame(width: geometry.size.width, height: geometry.size.width)

                Text(self.title)
                    .customFont(.semiBold, .medium)
                Toggle(isOn: self.$pointyEars) {
                    Text("Pointy ears")
                        .customFont(.semiBold, .medium)
                }
            }
        }
    }
}

struct PointView: View {

    var title: String

    @Binding var position: CGSize
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(LIGHT_TEXT_COLOR)
                .customFont(.semiBold, .small)
                .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
            Circle()
                .strokeBorder(LIGHT_TEXT_COLOR, lineWidth: 3)
                .background(Circle().foregroundColor(TEXT_COLOR))
                .frame(width: 12, height: 12)
        }
        .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
        .animation(.easeInOut, value: dragOffset)
        .gesture(
            DragGesture()
                .updating($dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded({ (value) in
                    self.position.height += value.translation.height
                    self.position.width += value.translation.width
                })
        )
    }
}

struct SetPointsView_Previews: PreviewProvider {
    static var previews: some View {
        SetPointsView()
    }
}
