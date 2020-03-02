import UIKit

extension UIContextualAction {
    
    convenience init(title: String, color: UIColor, callback: @escaping () -> ()) {
        self.init(style: .normal, title: title, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            callback()
            success(true)
        })
        self.backgroundColor = color
    }
}
