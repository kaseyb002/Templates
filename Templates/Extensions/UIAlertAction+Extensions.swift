import UIKit

extension UIAlertAction {
    
    convenience init(title: String,
                     style: UIAlertAction.Style = .default,
                     callback: @escaping () -> ()) {
        self.init(title: title, style: style, handler: { _ in callback() })
    }
}
