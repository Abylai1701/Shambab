import Foundation
import UIKit

extension UIViewController {
    func inNavigation() -> UIViewController {
        let navController = UINavigationController(rootViewController: self)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
}

extension UIView {
    func addSubviews(_ views : UIView...) -> Void {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}
extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}
