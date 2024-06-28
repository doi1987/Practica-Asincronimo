//
//  HomeViewModelTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import XCTest
import Combine
@testable import PracticaIOSAsincronismo

final class HomeViewModelTests: XCTestCase {
	private var sut: HomeViewModel!
	private var heroUseCaseMock: HeroUseCaseMock = .init()
	private var secureDataProviderMock: SecureDataProtocol = SecureDataProviderMock()
	private var cancellables: Set<AnyCancellable>!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		cancellables = .init()
		sut = HomeViewModel(heroUseCase: heroUseCaseMock,
							secureDataKeychain: secureDataProviderMock)
		
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenLoadHeroesWhenGetThenMatch() throws {
		let expectedHeroes: [HeroModel] = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
										   HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
										   HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		
		let expectation = XCTestExpectation(description: "Heroes loaded")
		expectation.expectedFulfillmentCount = 2
		
		var output: StatusLoad?
		sut.$homeStatusLoad
			.sink(receiveValue: { state in 
				output = state
				expectation.fulfill()
			})
			.store(in: &cancellables)
		heroUseCaseMock.result = .success(expectedHeroes)
		sut.loadHeroes()
		
		wait(for: [expectation], timeout: 0.1)
		
		
		
		let outputResult: StatusLoad = try XCTUnwrap(output)
		let heroResult: HeroModel = try XCTUnwrap(sut.dataHeroes.first)
		
		XCTAssertEqual(outputResult, .loaded)
		XCTAssertEqual(heroResult, expectedHeroes.sorted().first)
	}
	
	func testGivenLoadHeroesWhenGetThenMatchError() throws {
		let expectation = XCTestExpectation(description: "Heroes loaded")
		expectation.expectedFulfillmentCount = 2
		
		var output: StatusLoad?
		sut.$homeStatusLoad
			.sink(receiveValue: { state in 
				output = state
				expectation.fulfill()
			})
			.store(in: &cancellables)
		heroUseCaseMock.result = .failure(.serverError)
		sut.loadHeroes()
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult: StatusLoad = try XCTUnwrap(output)
		
		XCTAssertEqual(outputResult, .error(error: .serverError))
	}
	
	func testGivenTokenWhenLogoutThenMatchNoToken() throws {
		let token = "j,hvnsdkcgkxjkfhxftjhxthkcjgcjtk"
		secureDataProviderMock.setToken(value: token)
		let resultToken = try XCTUnwrap(secureDataProviderMock.getToken())
		XCTAssertEqual(resultToken, token)
		
		sut.logout()
		
		let resultNoToken = secureDataProviderMock.getToken()
		XCTAssertNil(resultNoToken)
	}
}
