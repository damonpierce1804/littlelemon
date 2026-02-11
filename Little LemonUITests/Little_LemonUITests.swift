//
//  Little_LemonUITests.swift
//  Little LemonUITests
//
//  Created by Jesus Cervantes on 2/4/26.
//

import XCTest

final class Little_LemonUITests: XCTestCase {

    override func setUpWithError() throws {
       

        
        continueAfterFailure = false

        
    }

    override func tearDownWithError() throws {
        
    }

    @MainActor
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()

       
    }

    @MainActor
    func testLaunchPerformance() throws {
        
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
