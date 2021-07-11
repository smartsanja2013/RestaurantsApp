//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Sanjeewa Gunathilake on 6/7/21.
//

import XCTest
@testable import Restaurants

class RestaurantsTests: XCTestCase {

    // test login success
    func test_LoginManager_WithValidRequest_Returns_LoginData(){

        // ARRANGE
        let loginManager = FirebaseAuthManager()
        let loginExpectations = expectation(description: "WithValidRequest_Returns_LoginData")
        let email = "test@test.com"
        let password = "test123"
        
        // ACT
        loginManager.authenticateUser(email:email, password: password) { (loginData) in
            // ASSERT
            XCTAssertNotNil(loginData)
            XCTAssertNil(loginData.errorMessage)
            XCTAssertEqual(email, loginData.response?.user.email)
            loginExpectations.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // test bad email format error
    func test_LoginManager_WithInValidRequest_Returns_Error(){

        // ARRANGE
        let loginManager = FirebaseAuthManager()
        let loginExpectations = expectation(description: "WithInValidRequest_Returns_Error")
        let email = "test@test"
        let password = "test123"
        

        // ACT
        loginManager.authenticateUser(email:email, password: password) { (loginData) in
            // ASSERT
            XCTAssertNotNil(loginData)
            XCTAssertNil(loginData.response)
            XCTAssertNotNil(loginData.errorMessage)
            XCTAssertEqual("The email address is badly formatted.", loginData.errorMessage!)

            loginExpectations.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // test login fail due to wrong email or password
    func test_LoginManager_WithValidRequest_Returns_Error(){

        // ARRANGE
        let loginManager = FirebaseAuthManager()
        let loginExpectations = expectation(description: "WithInValidRequest_Returns_Error")
        let email = "test@test.com"
        let password = "wrongpssword"
        

        // ACT
        loginManager.authenticateUser(email:email, password: password) { (loginData) in
            // ASSERT
            XCTAssertNotNil(loginData)
            XCTAssertNil(loginData.response)
            XCTAssertNotNil(loginData.errorMessage)
            XCTAssertEqual("The password is invalid or the user does not have a password.", loginData.errorMessage!)

            loginExpectations.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

}
