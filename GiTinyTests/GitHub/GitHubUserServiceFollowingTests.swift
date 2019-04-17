import XCTest
@testable import GiTiny

import Foundation

import Moya
import RxSwift

class GitHubUserServiceFollowingTests: XCTestCase {
    
    let accessToken = ""
    let provider = GiTinyProvider<GitHubUserService>()
    var disposeBag = DisposeBag()
    
    // MARK: - Tests
    
    func testGetStarred_isFollowing() {
        // Given
        let expectation = self.expectation(description: "testGetStarred_isFollowing")
        var result: Response!
        
        // When
        provider.rx.request(.getFollowing(accessToken: accessToken, username: "gottesmm"))
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
    
    func testGetStarred_isNotFollowing() {
        // Given
        let expectation = self.expectation(description: "testGetStarred_isNotFollowing")
        var result: Response!
        
        // When
        provider.rx.request(.getFollowing(accessToken: accessToken, username: "gottesmm"))
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
    
    func testPutFollowing() {
        // Given
        let expectation = self.expectation(description: "testPutStarred")
        var result: Response!
        
        // When
        provider.rx.request(.putFollowing(accessToken: accessToken, username: "gottesmm"))
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
    
    func testDeleteFollowing() {
        // Given
        let expectation = self.expectation(description: "testDeleteStarred")
        var result: Response!
        
        // When
        provider.rx.request(.deleteFollowing(accessToken: accessToken, username: "gottesmm"))
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
