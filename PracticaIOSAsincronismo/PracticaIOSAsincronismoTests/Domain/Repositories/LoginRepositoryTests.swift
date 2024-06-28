//
//  LoginRepository.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 28/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo

final class LoginRepositoryTests: XCTestCase {
	private var sut: LoginRepositoryProtocol!
	private let apiProviderMock: ApiProviderMock = .init()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = LoginRepository(apiProvider: apiProviderMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenEmailAndPasswordWhenLoginThenSuccessMatch() async throws {
		let email = "user@test"
		let password = "password"
		let expectedToken = "dfnsjfbdbj"
		apiProviderMock.login = .success(expectedToken)
				
		let result = await sut.loginWith(email: email, password: password)
		
		switch result {
		case .success(let token):
			XCTAssertEqual(token, expectedToken)
		case .failure:
			XCTFail("Expected success but got failure")
		}
		
	}
	
	func testGivenEmailAndPasswordWhenLoginThenErrorMatch() async throws {
		let email = "user@test"
		let password = "password"
		apiProviderMock.login = .failure(.noData)
		let result = await sut.loginWith(email: email, password: password)
		
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .noData)
		}
	}
}

