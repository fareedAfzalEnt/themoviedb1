//
//  themoviedbTests.swift
//  themoviedbTests
//
//  Created by Farid Afzal on 21/11/2023.
//

import XCTest
@testable import themoviedb

final class themoviedbTests: XCTestCase {
    func fetchTVShowData() {
        let expectation = XCTestExpectation(description: "API data received")
        let params = ["api_key": Constants.APIEnvionment.apiKey,
                      "language": "en-US",
                      "page": "\(1)"]
        let movieService = MovieService()

        movieService.fetchTVShowData(params: params)
            .receive(on: DispatchQueue.main)
            .sink {result in
                switch result {
                case .failure(let error):
                    XCTAssertNil(error)
                case .finished:
                    XCTAssertTrue(true, "API process complete")
                }
                expectation.fulfill()
            } receiveValue: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 30.0)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
