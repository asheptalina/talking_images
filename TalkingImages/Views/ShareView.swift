import SwiftUI

struct ShareView: View {
    
    var onCreateNewButton: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                downloadButton()
                shareButton()
            }
            createNewButton()
        }
    }
    
    func downloadButton() -> some View {
        return Button { 
            // TODO: download
        } label: { 
            HStack {
                Image("download_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.vertical, 25.0)
                Text("Download")
                    .foregroundColor(.white)
                    .customFont(.extraBold, .medium)
                    .padding(.vertical, 20)
            }.padding(.horizontal, 20)
        }
        .background(DOWNLOAD_BUTTON_COLOR)
        .cornerRadius(10.0)
    }
    
    func shareButton() -> some View {
        return Button { 
            // TODO: share
        } label: { 
            HStack {
                Image("share_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.vertical, 25.0)
                Text("Share")
                    .foregroundColor(.white)
                    .customFont(.extraBold, .medium)
                    .padding(.vertical, 20)
            }.padding(.horizontal, 20)
        }
        .background(SHARE_BUTTON_COLOR)
        .cornerRadius(10.0)
    }
    
    func createNewButton() -> some View {
        return Button { 
            self.onCreateNewButton()
        } label: { 
            HStack {
                Text("Create new animation")
                    .foregroundColor(.white)
                    .customFont(.extraBold, .medium)
                    .padding(.vertical, 20)
            }.padding(.horizontal, 20)
        }
        .background(CREATE_NEW_BUTTON_COLOR)
        .cornerRadius(10.0)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(onCreateNewButton: {})
    }
}
