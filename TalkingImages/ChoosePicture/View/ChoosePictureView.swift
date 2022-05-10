import SwiftUI

struct ChoosePictureView: View {

    @State private var showCameraImagePicker = false
    @State private var showGalleryImagePicker = false

    var onImageSelect: (UIImage) -> Void

    let firstTimeTitleShownKey = "FirstTimeTitleShown"

    private let firstTimeTitle = "Let’s create your first animation!"
    private let title = "Create your unique animations!"

    let defaultPicturesNames = [
        "default_picture_1",
        "default_picture_2",
        "default_picture_3",
        "default_picture_4",
        "default_picture_5",
        "default_picture_6",
        "default_picture_7",
        "default_picture_8",
        "default_picture_9",
        "default_picture_10",
        "default_picture_11",
        "default_picture_12"
    ]

    // UI constants
    private let titlePaddingTopCoef = 0.1
    private let titlePaddingHorizontalCoef = 0.09
    private let titlePaddingBottomCoef = 0.07

    private let buttonsHeightCoef = 0.1
    private let buttonsIconHeightCoef = 0.47
    private let buttonsSpacingCoef = 0.03
    private let buttonsPaddingBottomCoef = 0.1

    private let paddingHorizontalCoef = 0.03

    private let appIconSizeCoef = 0.26
    private let appIconPaddingTopCoef = 0.15
    private let appIconPaddingLeadingCoef = 0.02

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Image(APP_ICON_SMALL)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geometry.size.width * self.appIconSizeCoef,
                                height: geometry.size.width * self.appIconSizeCoef
                            )
                            .padding(.top, geometry.size.width * self.appIconPaddingTopCoef)
                            .padding(.leading, geometry.size.width * self.appIconPaddingLeadingCoef)
                    }
                    Spacer()
                }
                VStack(spacing: 0.0) {
                    Text(self.getTitle())
                        .customFont(.semiBold, .large, color: TEXT_COLOR)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(
                            top: geometry.size.width * self.titlePaddingTopCoef,
                            leading: geometry.size.width * self.titlePaddingHorizontalCoef,
                            bottom: geometry.size.width * self.titlePaddingBottomCoef,
                            trailing: geometry.size.width * self.titlePaddingHorizontalCoef
                        ))

                    HStack(spacing: geometry.size.width * self.buttonsSpacingCoef) {
                        self.getGalleryButton(height: geometry.size.height * self.buttonsHeightCoef)
                        self.getCameraButton(height: geometry.size.height * self.buttonsHeightCoef)
                    }
                    .padding(.bottom, geometry.size.width * self.buttonsPaddingBottomCoef)

                    self.getDefaultImages()
                }.padding(.horizontal, geometry.size.width * paddingHorizontalCoef)
            }
            .sheet(isPresented: self.$showCameraImagePicker) {
                ImagePicker(sourceType: .camera, onImageSelect: self.onImageSelect)
            }
            .sheet(isPresented: self.$showGalleryImagePicker) {
                ImagePicker(sourceType: .photoLibrary, onImageSelect: self.onImageSelect)
            }
        }
    }

    private func getTitle() -> String {
        if UserDefaults.standard.bool(forKey: self.firstTimeTitleShownKey) {
            return self.title
        } else {
            UserDefaults.standard.set(true, forKey: firstTimeTitleShownKey)
            UserDefaults.standard.synchronize()
            return firstTimeTitle
        }
    }

    func getGalleryButton(height: CGFloat) -> some View {
        return Button {
            self.showGalleryImagePicker = true

        } label: {
            HStack {
                Spacer()
                Image(GALLERY_ICON)
                    .resizable()
                    .scaledToFit()
                    .frame(height: self.buttonsIconHeightCoef * height)
                Spacer()
            }
        }
        .frame(height: height)
        .background(GALLERY_BUTTON_COLOR)
        .cornerRadius(10.0)
    }

    func getCameraButton(height: CGFloat) -> some View {
        return Button {
            self.showCameraImagePicker = true
        } label: {
            HStack {
                Spacer()
                Image(CAMERA_ICON)
                    .resizable()
                    .scaledToFit()
                    .frame(height: self.buttonsIconHeightCoef * height)
                Spacer()
            }
        }
        .frame(height: height)
        .background(CAMERA_BUTTON_COLOR)
        .cornerRadius(10.0)
    }

    private func getDefaultImages() -> some View {
        return GeometryReader { geometry in
            let gridSpacing = 8.0
            let imageSize = (geometry.size.width - gridSpacing * 2) / 3
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: gridSpacing) {
                    ForEach(self.defaultPicturesNames, id: \.self) { imageName in
                        Group {
                            Button {
                                if let image = UIImage(named: imageName) {
                                    self.onImageSelect(image)
                                }
                            } label: {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: imageSize, height: imageSize)
                            }
                        }

                    }
                }
            }
        }
    }
}

struct ChoosePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePictureView(onImageSelect: { _ in })
    }
}
