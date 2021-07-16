//
//  AcronymTests.swift
//  AcronymTests
//
//  Created by Ashish Vani on 16/07/21.
//

import XCTest
@testable import Acronym

class AcronymTests: XCTestCase {
    var vmSeach:SearchViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try? super.setUpWithError()
        vmSeach = SearchViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vmSeach = nil
        try? super.tearDownWithError()
    }

    func testIsValidedTextInput() throws {
        let strSearch = "aa124343534"

        let valid:Validation = vmSeach.isValidedTextInput(entered: strSearch)

        XCTAssertTrue(valid.isValid, (valid.error ?? "Invalid text"))
    }


}
