//
//  LoginViewModelTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo
import Combine

final class LoginViewModelTests: XCTestCase {
	private var sut: LoginViewModel!
	private let loginUseCaseMock: LoginUseCaseMock = .init()
	private var cancellables: Set<AnyCancellable>!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		cancellables = .init()
		sut = LoginViewModel(loginUseCase: loginUseCaseMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenEmailAndPasswordWhenLoginSuccessThenStateMatch() throws {
		let email = "email"
		let password = "password"
		
		let expectation = expectation(description: "Login success and token stored")
		expectation.expectedFulfillmentCount = 2
		
		var output: LoginState?
		
		sut.$loginState
			.sink(receiveValue: { state in 
				output = state
				expectation.fulfill()
			})
			.store(in: &cancellables)
		
		loginUseCaseMock.result = .success("token")
		
		sut.loginWith(email: email, password: password)
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .success) 
		
	}
	
	func testGivenEmailAndPasswordWhenLoginFailThenStateMatch() throws {
		let email = "email"
		let password = "password"
		
		let expectation = expectation(description: "Logon success and token stored")
		expectation.expectedFulfillmentCount = 2
		var output: LoginState?
		
		sut.$loginState
			.sink(receiveValue: { state in 
				output = state
				expectation.fulfill()
			})
			.store(in: &cancellables)
		
		loginUseCaseMock.result = .failure(.unauthorized)
		sut.loginWith(email: email, password: password)
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .failed(.unauthorized)) 
	}
	
	func testGivenNoEmailWhenIsNotValidThenMatch() throws {
		let email: String = ""
		
		let output = sut.isValid(email: email)
		
		XCTAssertTrue(output)
	}
	
	func testGivenEmailWhenIsValidThenMatch() throws {
		let email: String = "goku@dragonball.com"
		
		let output = sut.isValid(email: email)
		
		XCTAssertTrue(output)
	}
	
	func testGivenPassWithLessThanFourCharsWhenIsNotValidThenMatch() throws {
		let pass: String = "pas"
		
		let output = sut.isValid(password: pass)
		
		XCTAssertTrue(output)
	}
	
	func testGivenPassWithMoreThanThreeCharsWhenIsValidThenMatch() throws {
		let pass: String = "aaaaa"
		
		let output = sut.isValid(password: pass)
		
		XCTAssertTrue(output)
	}
}
