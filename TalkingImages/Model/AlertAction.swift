import Foundation

struct AlertAction: Equatable, Hashable {

    var label: String
    var isCancel = false
    var action: () -> Void

    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.label == rhs.label && lhs.isCancel == rhs.isCancel
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.label)
        hasher.combine(self.isCancel)
    }
}
