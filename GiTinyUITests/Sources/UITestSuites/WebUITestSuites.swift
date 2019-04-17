import UIKit

import PanModal

struct WebUITestSuite: UITestSuitable {
    
    var testRunnerVC: UIViewController
    
    func runUITests() {
        testWebViewController()
    }
    
    // MARK: - Tests
    
    private func testWebViewController() {
        let controller = WebViewController(viewModel: .init(), urlString: "https://github.com/k-lpmg/GiTiny/blob/master/README.md")
        testRunnerVC.presentPanModal(controller)
    }
    
}
