import UIKit

protocol UITestSuitable {
    
    // MARK: - Properties
    
    var testRunnerVC: UIViewController { get }
    var testRunnerView: UIView { get }
    
    // MARK: - Constructor
    
    init(testRunnerVC: UIViewController)
    
    // MARK: - Methods
    
    func present(_ controller: UIViewController)
    func runUITests()
    
}

extension UITestSuitable {
    
    var testRunnerView: UIView {
        return testRunnerVC.view
    }
    
    func present(_ controller: UIViewController) {
        testRunnerVC.present(controller, animated: false)
    }
    
    func push(_ controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController)
    }
    
}
