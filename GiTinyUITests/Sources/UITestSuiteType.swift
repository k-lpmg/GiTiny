enum UITestSuiteType {
    case web
    
    var testSuite: UITestSuitable.Type {
        switch self {
        case .web:
            return WebUITestSuite.self
        }
    }
}
