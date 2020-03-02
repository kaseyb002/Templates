import UIKit

extension UITableViewCell {
    
    ///Creates UITableViewCell from Xib
    static func dequeue<T: UITableViewCell>(
        tableViewCell: T.Type,
        tableView: UITableView,
        indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: className)
        let cell = tableView.dequeueReusableCell(withIdentifier: className,
                                                 for: indexPath) as! T
        return cell
    }
}
