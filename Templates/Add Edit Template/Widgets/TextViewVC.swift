import UIKit

final class TextViewVC: UIViewController {
    
    // MARK: Required inits for Xibs
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) missing")}
    override var nibName: String? { return String(describing: type(of: self)) }
    
    init(_ config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    // MARK: Data Properties
    private let config: Config
    var text: String { return textView.text }
    var currentNumberOfLines: Int {
        guard let lineHeight = textView.font?.lineHeight else { return 1 }
        return Int(textView.contentSize.height / lineHeight)
    }
    var lineHeight: CGFloat {
        return textView.font!.lineHeight
    }
    
    // MARK: Views
    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var textView: UITextView!
}

// MARK: Lifecycle
extension TextViewVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViewUI()
    }
}

// MARK: Actions
extension TextViewVC {
    
    func focus() {
        textView.becomeFirstResponder()
    }
    
    func unFocus() {
        textView.resignFirstResponder()
    }
    
    func set(text: String) {
        textView.text = text
    }
    
    func set(font: UIFont) {
        textView.font = font
    }
    
    func applyAutoCorrect() {
        unFocus()
        focus()
    }
}

// MARK: UITextViewDelegate
extension TextViewVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        config.letterPressed(text)
    }
}

// MARK: Update UI
extension TextViewVC {
    
    private func setupTextViewUI() {
        textView.text = config.presetText
    }
}

// MARK: Config
extension TextViewVC {
    
    struct Config {
        let presetText: String?
        let letterPressed: (String) -> ()
    }
    
    enum BorderStyle {
        case line
        case shadow
        case none
    }
}
