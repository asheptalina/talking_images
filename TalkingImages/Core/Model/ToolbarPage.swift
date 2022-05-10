import SwiftUI

enum ToolbarPage: Int {
    case choosePicture
    case edit
    case setPoints
    case voice
    case share

    var imageName: String {
        switch self {
        case .choosePicture:
            return MENU_CHOOSE_PICTURE
        case .edit:
            return MENU_EDIT
        case .setPoints:
            return MENU_SET_POINTS
        case .voice:
            return MENU_VOICE
        case .share:
            return MENU_SHARE
        }
    }

    var color: Color {
        switch self {
        case .choosePicture:
            return MENU_CHOOSE_PICTURE_COLOR
        case .edit:
            return MENU_EDIT_COLOR
        case .setPoints:
            return MENU_SET_POINTS_COLOR
        case .voice:
            return MENU_VOICE_COLOR
        case .share:
            return MENU_SHARE_COLOR
        }
    }
}
