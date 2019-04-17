import UIKit

class UITestRunnerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainTestSuite: UITestSuiteType = .web
    
    // MARK: - Overridden: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        startTestSuite(type: mainTestSuite)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        title = "UITestRunner"
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }
    
    private func startTestSuite(type: UITestSuiteType) {
        return type.testSuite.init(testRunnerVC: self).runUITests()
    }
    
}
