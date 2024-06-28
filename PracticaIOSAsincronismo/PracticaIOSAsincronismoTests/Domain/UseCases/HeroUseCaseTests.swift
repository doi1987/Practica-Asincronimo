//
//  HeroUseCaseTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo

final class HeroUseCaseTests: XCTestCase {
	private var sut: HeroUseCaseProtocol!
	private var heroRepositoryMock: HeroRepositoryMock = HeroRepositoryMock()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = HeroUseCase(heroRepository: heroRepositoryMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenNoNameWhenGetHeroesThenSuccessMatch() async throws {
		let expectedHeroes: [HeroModel] = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
										   HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
										   HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		
		heroRepositoryMock.result = .success(expectedHeroes)

		let result = await sut.getHeroes(name: "")

		switch result {
		case .success(let heroes):
			XCTAssertEqual(heroes.count, 3, "Expected 3 heroes")
			XCTAssertEqual(heroes, expectedHeroes)
		case .failure:
			XCTFail("Expected success but got failure")
		}
	}
	
	func testGivenNoNameWhenGetHeroesThenErrorMatch() async throws {
		
		heroRepositoryMock.result = .failure(.malformedURL)
		let result = await sut.getHeroes(name: "")
		
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .malformedURL)
		}
	}
}
