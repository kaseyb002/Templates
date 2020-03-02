import UIKit

protocol Keyboardable: AnyObject {
    var bottomConstraints: [NSLayoutConstraint] { get }
    var bottomKeyboardPadding: CGFloat { get }
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}

extension Keyboardable {
    
    var bottomKeyboardPadding: CGFloat {
        return 0
    }
}

extension Keyboardable where Self: UIViewController {
    
    func setupKeyboardHidingShowingNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            let keyboardSize: CGSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
            // push up content for keyboard
            view.layoutIfNeeded()
            UIView.animate(withDuration: 0.4) {
                self.adjustForKeyboard(showing: true, keyboardHeight: keyboardSize.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4) {
            self.adjustForKeyboard(showing: false)
            self.view.layoutIfNeeded()
        }
    }
    
    /// Adjusts constraints based on whether keyboard is showing
    private func adjustForKeyboard(showing: Bool, keyboardHeight: CGFloat = 0) {
        if showing {
            for constraint in bottomConstraints {
                let distance = UIScreen.main.bounds.maxY - constraint.getMaxY
                let bottomPadding = keyboardHeight + bottomKeyboardPadding - distance
                constraint.constant = bottomPadding
            }
            return
        }
        
        for constraint in bottomConstraints {
            constraint.constant = bottomKeyboardPadding
        }
    }
}

private extension NSLayoutConstraint {
    
    var getMaxY: CGFloat {
        
        func getMaxY(for item: AnyObject?) -> CGFloat {
            guard let view = item as? UIView else { return 0 }
            let maxY = CGPoint(x: 0, y: view.frame.maxY)
            return min(UIScreen.main.bounds.maxY,
                       view.convert(maxY, to: nil).y)
        }
        
        return max(getMaxY(for: firstItem),
                   getMaxY(for: secondItem))
    }
}
