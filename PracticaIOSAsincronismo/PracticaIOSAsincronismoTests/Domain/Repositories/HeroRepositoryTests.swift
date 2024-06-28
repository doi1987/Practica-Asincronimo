//
//  HeroRepositoryTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo

final class HeroRepositoryTests: XCTestCase {
	private var sut: HeroRepositoryProtocol!
	private let apiProviderMock: ApiProviderMock = .init()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = HeroRepository(apiProvider: apiProviderMock)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenNoNameWhenGetHeroesThenSuccessMatch() async throws {
		let expectedHeroes: [HeroModel] = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
										   HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
										   HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		
		apiProviderMock.heroes = .success(expectedHeroes)
		
		let result = await sut.getHeroesWith(name: "")
		
		switch result {
		case .success(let heroes):
			XCTAssertEqual(heroes.count, 3, "Expected 3 hero")
			XCTAssertEqual(heroes, expectedHeroes)
			
		case .failure:
			XCTFail("Expected success but got failure")
		}
		
	}
	
	func testGivenHeroNameWhenGetHeroesThenSuccessMatch() async throws {
		let expectedHero: HeroModel =  HeroModel(id: "1",
												 name: "Diego",
												 description: "Superman",
												 photo: "",
												 favorite: true)
		apiProviderMock.heroes = .success([expectedHero])
		
		let heroName = "random"
		
		let result = await sut.getHeroesWith(name: heroName)
		
		switch result {
		case .success(let heroes):
			XCTAssertEqual(heroes.count, 1, "Expected 1 hero")
			XCTAssertEqual(heroes.first, expectedHero)
			
		case .failure:
			XCTFail("Expected success but got failure")
		}
		
	}
	
	func testGivenNoNameWhenGetHeroesThenErrorMatch() async throws {
		apiProviderMock.heroes = .failure(.noData)
		let result = await sut.getHeroesWith(name: "")
		
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .noData)
		}
	}
}

