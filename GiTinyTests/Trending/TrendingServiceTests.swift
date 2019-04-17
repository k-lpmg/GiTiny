import XCTest
@testable import GiTiny

import Foundation

import Moya
import RxSwift

class TrendingServiceTests: XCTestCase {
    
    let provider = MoyaProvider<TrendingService>()
    var disposeBag = DisposeBag()
    
    // MARK: - Tests
    
    func testRepositories() {
        // Given
        let expectation = self.expectation(description: "testSearchRepositores")
        var result: [TrendingRepository]!
        
        // When
        provider.rx.request(.repositories(language: nil, since: .daily))
            .map([TrendingRepository].self)
            .subscribe(onSuccess: { (model) in
                result = model
                expectation.fulfill()
            }) { (error) in
                XCTFail(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testDevelopers() {
        // Given
        let expectation = self.expectation(description: "testDevelopers")
        var result: [TrendingDeveloper]!
        
        // When
        provider.rx.request(.developers(language: nil, since: .daily))
            .map([TrendingDeveloper].self)
            .subscribe(onSuccess: { (model) in
                result = model
                expectation.fulfill()
            }) { (error) in
                XCTFail(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testLanguages() {
        // Given
        let expectation = self.expectation(description: "testLanguages")
        var result: TrendingLanguages!
        
        // When
        provider.rx.request(.languages)
            .map(TrendingLanguages.self)
            .subscribe(onSuccess: { (model) in
                result = model
                expectation.fulfill()
            }) { (error) in
                XCTFail(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
    }
    
}
