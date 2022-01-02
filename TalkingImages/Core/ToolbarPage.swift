import SwiftUI

enum ToolbarPage {
    case ChoosePicture
    case Edit
    case SetPoints
    case Voice
    case Share
    
    var imageName: String {
        switch self {
        case .ChoosePicture:
            return MENU_CHOOSE_PICTURE
        case .Edit:
            return MENU_EDIT
        case .SetPoints:
            return MENU_SET_POINTS
        case .Voice:
            return MENU_VOICE
        case .Share:
            return MENU_SHARE
        }
    }
    
    var color: Color {
        switch self {
        case .ChoosePicture:
            return MENU_CHOOSE_PICTURE_COLOR
        case .Edit:
            return MENU_EDIT_COLOR
        case .SetPoints:
            return MENU_SET_POINTS_COLOR
        case .Voice:
            return MENU_VOICE_COLOR
        case .Share:
            return MENU_SHARE_COLOR
        }
    }
}
