//
//  HeroDetailViewModelTests.swift
//  PracticaIOSAsincronismoTests
//
//  Created by David Ortega Iglesias on 27/6/24.
//

import XCTest
@testable import PracticaIOSAsincronismo
import Combine

final class HeroDetailViewModelTests: XCTestCase {

	private let transformationsUseCaseMock: TransformationsUseCaseMock = .init()
    private var sut: HeroDetailViewModel!
	private let hero: HeroModel = HeroModel(id: "1",
											name: "Diego",
											description: "Superman",
											photo: "",
											favorite: true) 
	private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
		try super.setUpWithError()
		cancellables = .init()
		sut = .init(hero: hero,
					transformationsUseCase: transformationsUseCaseMock)
    }

    override func tearDownWithError() throws {
        sut = nil
		try super.tearDownWithError()
    }
	
	func testGivenAnInitialHeroWhenGetHeroTheMatch() throws {
		let output = sut.getHero()
		XCTAssertEqual(output, hero)
		let name = try XCTUnwrap(sut.heroNameAndId().name)
		let id = try XCTUnwrap(sut.heroNameAndId().id)
		
		XCTAssertEqual(name, hero.name)
		XCTAssertEqual(id, hero.id)
	}
    
    func testGivenLoadTransformationsWhenGetThenMatchSuccess() throws {  
		let expectedTransformations = [TransformationModel(id: "1", name: "ozaru", description: "Es una bestia", photo: nil)]
		let expectation = XCTestExpectation(description: "Load detail")
		expectation.expectedFulfillmentCount = 2
		
		var output: StatusLoad?
		sut.$heroDetailStatusLoad
			.sink(receiveValue: { state in 
				output = state
				expectation.fulfill()
			})
			.store(in: &cancellables)

		transformationsUseCaseMock.result = .success(expectedTransformations)
		sut.loadTransformations()
		
		wait(for: [expectation], timeout: 0.1)
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .loaded)

		let outputTransformations = sut.getTransformations()
		XCTAssertEqual(outputTransformations, expectedTransformations)
    }
	
	func testGivenLoadTransformationsWhenGetThenMatchError() throws {
		let expectation = XCTestExpectation(description: "Load detail")
		expectation.expectedFulfillmentCount = 2
		
		var output: StatusLoad?
		sut.$heroDetailStatusLoad
			.sink(receiveValue: { state in 
				output = state
				expectation.fulfill()
			})
			.store(in: &cancellables)
		transformationsUseCaseMock.result = .failure(.other)
		sut.loadTransformations()
		
		wait(for: [expectation], timeout: 0.1)
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .error(error: .other))
	}
}
