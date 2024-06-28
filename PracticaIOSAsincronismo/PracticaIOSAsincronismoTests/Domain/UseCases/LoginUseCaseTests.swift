//
//  LoginUseCaseTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 28/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo

final class LoginUseCaseTests: XCTestCase {
	private var sut: LoginUseCaseProtocol!
	private var loginRepositoryMock: LoginRepositoryMock = LoginRepositoryMock()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = LoginUseCase(loginRepository: loginRepositoryMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenAnEmailAndPasswordWhenLoginThenSuccessMatch() async throws {
		let email = "user@test"
		let password = "password"
		let expectedToken = "dfnsjfbdbj"
		
		loginRepositoryMock.result = .success(expectedToken)
		
		let result = await sut.loginWith(email: email, password: password)

		switch result {
		case .success(let token):
			XCTAssertEqual(token, expectedToken)
		case .failure:
			XCTFail("Expected success but got failure")
		}
	}
	
	func testGivenAnEmailAndPasswordWhenLoginThenErrorMatch() async throws {
		let email = "user@test"
		let password = "password"
		
		loginRepositoryMock.result = .failure(.unauthorized)
		
		let result = await sut.loginWith(email: email, password: password)
		
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .unauthorized)
		}
	}
}
