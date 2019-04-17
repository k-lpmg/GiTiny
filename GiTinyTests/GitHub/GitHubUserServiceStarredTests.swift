import XCTest
@testable import GiTiny

import Foundation

import Moya
import RxSwift

class GitHubUserServiceStarredTests: XCTestCase {
    
    let accessToken = ""
    let provider = GiTinyProvider<GitHubUserService>()
    var disposeBag = DisposeBag()
    
    // MARK: - Tests
    
    func testGetStarred_isStarred() {
        // Given
        let expectation = self.expectation(description: "testGetStarred_isStarred")
        var result: Response!
        
        // When
        provider.rx.request(.getStarred(accessToken: accessToken, owner: "nekonora", repo: "TaggerKit"))
            .subscribe(onSuccess: { (response) in
                result = response
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.statusCode, 204)
    }
    
    func testGetStarred_isNotStarred() {
        // Given
        let expectation = self.expectation(description: "testGetStarred_isNotStarred")
        var result: Response!
        
        // When
        provider.rx.request(.getStarred(accessToken: accessToken, owner: "nekonora", repo: "TaggerKit"))
            .subscribe(onSuccess: { (response) in
                result = response
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.statusCode, 404)
    }
    
    func testPutStarred() {
        // Given
        let expectation = self.expectation(description: "testPutStarred")
        var result: Response!
        
        // When
        provider.rx.request(.putStarred(accessToken: accessToken, owner: "nekonora", repo: "TaggerKit"))
            .subscribe(onSuccess: { (response) in
                result = response
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.statusCode, 204)
    }
    
    func testDeleteStarred() {
        // Given
        let expectation = self.expectation(description: "testDeleteStarred")
        var result: Response!
        
        // When
        provider.rx.request(.deleteStarred(accessToken: accessToken, owner: "nekonora", repo: "TaggerKit"))
            .subscribe(onSuccess: { (response) in
                result = response
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 30)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.statusCode, 204)
    }
    
}
