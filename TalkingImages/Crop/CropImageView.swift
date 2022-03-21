import SwiftUI

struct RectHole: Shape {
    let holeSize: CGSize
    
    let topLeftPoint: CGPoint 
    let bottomRight: CGPoint
    
    func path(in rect: CGRect) -> Path {
        let path = CGMutablePath()
        path.move(to: rect.origin)
        path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: rect.origin)
        path.closeSubpath()
        
        let newRect = CGRect(origin: .init(x: rect.midX - holeSize.width/2.0, y: rect.midY - holeSize.height/2.0), size: holeSize)
        
        path.move(to: self.topLeftPoint)
        path.addLine(to: .init(x: bottomRight.x, y: topLeftPoint.y))
        path.addLine(to: .init(x: bottomRight.x, y: bottomRight.y))
        path.addLine(to: .init(x: topLeftPoint.x, y: bottomRight.y))
        path.addLine(to: newRect.origin)
        path.closeSubpath()
        return Path(path)
    }
}

struct CropImageView: View {
    
    var cropViewSize: CGSize
    
    @Binding var rawImage: Image?
    
    @State private var scale: CGFloat = 1.0
    @State var cropSize: CGSize
    
    @State private var topLeftPoint: CGPoint
    @State private var topRightPoint: CGPoint
    @State private var bottomLeftPoint: CGPoint
    @State private var bottomRightPoint: CGPoint
    
    @State private var offset = CGSize.zero
    
    init(cropViewSize: CGSize, rawImage: Binding<Image?>) {
        self.cropViewSize = cropViewSize
        self._rawImage = rawImage
        
        self.cropSize = CGSize(width: cropViewSize.width * 0.8, height: cropViewSize.height * 0.8)
        self.topLeftPoint = CGPoint(x: cropViewSize.width * 0.1, y: cropViewSize.height * 0.1)
        self.topRightPoint = CGPoint(x: cropViewSize.width * 0.9, y: cropViewSize.height * 0.1)
        self.bottomLeftPoint = CGPoint(x: cropViewSize.width * 0.1, y: cropViewSize.height * 0.9)
        self.bottomRightPoint = CGPoint(x: cropViewSize.width * 0.9, y: cropViewSize.height * 0.9)
    }
    
    var body: some View {
            ZStack {
                self.imageView()                
                RectHole(holeSize: self.cropSize, topLeftPoint: self.topLeftPoint, bottomRight: self.bottomRightPoint)
                    .fill(Color(UIColor.black.withAlphaComponent(0.5)), style: FillStyle(eoFill: true, antialiased: true))
//                Rectangle()
//                    .stroke(Color.white, lineWidth: 2)
//                    .frame(width: cropSize.width, height: cropSize.height)
//                    .position(x: topLeftPoint.x + cropSize.width / 2, y: topLeftPoint.y + cropSize.height / 2)
                
                self.points()
                
            }
            .frame(width: cropViewSize.width, height: cropViewSize.width)
        
    }
    
    private func imageView() -> some View {
        return self.rawImage!
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(self.scale)
//            .highPriorityGesture(
//                MagnificationGesture()
//                    .onChanged { value in
//                        let newScale = self.scale * value.magnitude;
//                        let roundedScale = round(self.scale * 10000) / 10000.0
//                        let roundedNewScale = round(newScale * 10000) / 10000.0
//                        if roundedScale != roundedNewScale {
//                            self.scale = newScale
//                        }
//                    }
//                    .onEnded { value in
//                        self.scale = self.scale * value.magnitude
//                    }
//            )
//            .highPriorityGesture(
//                DragGesture()
//                    .onChanged { value in
//                        self.imageDragAmount = CGSize(
//                            width: self.imageXoffset + value.translation.width,
//                            height: self.imageYoffset + value.translation.height
//                        )
//                    }.onEnded { value in
//                        self.imageXoffset += value.translation.width
//                        self.imageYoffset += value.translation.height
//                        self.imageDragAmount = CGSize(
//                            width: self.imageXoffset,
//                            height: self.imageYoffset
//                        )
//                    }
//            )
    }
    
    private func points() -> some View {
        return ZStack {
            Circle()
                .fill(.red)
                .frame(width: 10, height: 10)
                .position(x: topLeftPoint.x, y: topLeftPoint.y)
                .offset(self.offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { value in
                            self.topLeftPoint.x = self.topLeftPoint.x + self.offset.width
                            self.topLeftPoint.y = self.topLeftPoint.y + self.offset.height
                            
                            self.bottomLeftPoint.x = self.bottomLeftPoint.x + self.offset.width
                            self.topRightPoint.y = self.topRightPoint.y + self.offset.height
                            
                            self.offset = .zero
                        }
                )
//            Circle()
//                .fill(.green)
//                .frame(width: 10, height: 10)
//                .position(x: topRightPoint.x, y: topRightPoint.y)
//                .offset(self.offset)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            offset = value.translation
//                        }
//                        .onEnded { value in
//                            self.topLeftPoint.x = self.topLeftPoint.x + self.offset.width
//                            self.topLeftPoint.y = self.topLeftPoint.y + self.offset.height
//                            
//                            self.bottomLeftPoint.x = self.bottomLeftPoint.x + self.offset.width
//                            self.topRightPoint.y = self.topRightPoint.y + self.offset.height
//                            
//                            self.offset = .zero
//                        }
//                )
        }
    }
    
}

struct CropImageView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            CropImageView(
                cropViewSize: CGSize(width: geometry.size.width, height: geometry.size.width), 
                rawImage: .constant(Image("default_picture_1"))
            )
        }
    }
}
