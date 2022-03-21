import SwiftUI

struct ChoosePictureView: View {

    @EnvironmentObject var viewModel: TalkingImagesViewModel

    @State private var showCameraImagePicker = false
    @State private var showGalleryImagePicker = false

    var onComplete: () -> Void

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
    private let buttonsHeightCoef = 0.1
    private let buttonsIconHeightCoef = 0.47

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                Text(self.getTitle())
                    .customFont(.semiBold, .large)
                    .padding(EdgeInsets(top: 50, leading: 45, bottom: 34, trailing: 51))

                HStack(spacing: 16.0) {
                    self.getGalleryButton(height: geometry.size.height * self.buttonsHeightCoef)
                    self.getCameraButton(height: geometry.size.height * self.buttonsHeightCoef)
                }
                .padding(.bottom, 48)

                self.getDefaultImages()
            }
            .padding(.horizontal, 16.0)
            .sheet(isPresented: self.$showCameraImagePicker) {
                ImagePicker(sourceType: .camera, selectedImage: self.$viewModel.rawImage)
            }
            .sheet(isPresented: self.$showGalleryImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$viewModel.rawImage)
            }
            .onChange(of: self.viewModel.rawImage) { _ in
                self.viewModel.clear()
                self.onComplete()
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
                            let image = Image(imageName)
                                .resizable()
                            Button {
                                viewModel.rawImage = image
                            } label: {
                                image
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
        ChoosePictureView(onComplete: {})
    }
}
