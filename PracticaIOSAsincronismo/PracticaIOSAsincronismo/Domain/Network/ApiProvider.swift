//
//  ApiProvider.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

// Endpoints de la api
enum Endpoints {
	case login
	case heroes
	case transformations
	case locations
	
	func endpoint() -> String {
		switch self {
		case .login:
			return "api/auth/login"
		case .heroes:
			return "api/heros/all"
		case .transformations:
			return "api/heros/tranformations"
		case .locations:
			return "api/heros/locations"
		}
	}
	
	func httpMethod() -> String {
		switch self {
		case .login, .heroes, .transformations, .locations:
			return "POST"
		}
	}
}


// Crea request para un endpoint dado
struct RequestProvider {
	let host = URL(string: "https://dragonball.keepcoding.education")!
	
	func requestFor(endpoint: Endpoints) -> URLRequest {
		let url = host.appendingPathComponent(endpoint.endpoint())
		var request = URLRequest.init(url: url)
		request.httpMethod = endpoint.httpMethod()
		return request
	}
	
	func requestFor(endpoint: Endpoints, token:String, params: [String: Any]) -> URLRequest {
		
		var request = self.requestFor(endpoint: endpoint)
		let jsonParameters = try? JSONSerialization.data(withJSONObject: params)
		request.httpBody = jsonParameters
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		
		return request
	}
}

protocol ApiProviderProtocol {
	func loginWith(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void)
	func getHeroesWith(name: String?, completion: @escaping (Result<[HeroModel], NetworkError>) -> Void)
	func getTransformationsForHeroWith(id: String,completion: @escaping (Result<[TransformationModel], NetworkError>) -> Void)
}

class ApiProvider: ApiProviderProtocol {
	private var session: URLSession
	private var requestProvider: RequestProvider
	private var secureData: SecureDataProtocol
	
	// Creamos ApiPRovider con session, requestPRovider y secureData
	// Al inyectarlos nos permitirá pasar los valores que necesitamos al crear la clase
	// especialmente útil para testing, se asignan valores por defecto si se proveen
	
	init(session: URLSession = URLSession.shared,
		 requestProvider: RequestProvider = RequestProvider(),
		 secureData: SecureDataProtocol = SecureDataKeychain()) {
		self.session = session
		self.requestProvider = requestProvider
		self.secureData = secureData
	}
	
	
	// Llamada al servicio login
	func loginWith(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
		guard let loginData = String(format: "%@:%@", email, password).data(using: .utf8)?.base64EncodedString() else {
			completion(.failure(.dataFormatting))
			return
		}
		var request = requestProvider.requestFor(endpoint: .login)
		request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
		makeRequestfor(request: request, completion: completion)
	}
	
	func getHeroesWith(name: String? = nil, completion: @escaping (Result<[HeroModel], NetworkError>) -> Void) {
		guard let token = secureData.getToken() else {
			completion(.failure(.tokenFormatError))
			return
		}
		
		let request = requestProvider.requestFor(endpoint: .heroes, token: token, params: ["name": name ?? ""])
		makeDataRequestfor(request: request, completion: completion)
	}
	
	func getTransformationsForHeroWith(id: String,
									   completion: @escaping (Result<[TransformationModel], NetworkError>) -> Void) {
		//TODO: - MAnage error getting token
		let token = secureData.getToken()!
		let request = requestProvider.requestFor(endpoint: .transformations, token: token, params: ["id": id])
		makeDataRequestfor(request: request, completion: completion)
	}
}

extension ApiProvider {
	
	func makeRequestfor(request: URLRequest, completion: @escaping (Result<String, NetworkError>) -> Void) {
		session.dataTask(with: request) { data, response, error in
			guard let response = response as? HTTPURLResponse else {
				completion(.failure(.serverError))
				return
			}
			
			guard response.statusCode != 500 else { 
				completion(.failure(.serverError))
				return
			}

			guard response.statusCode != 401 else { 
					completion(.failure(.unauthorized))
				return
			}
			
			guard let data = data else { 
				completion(.failure(.noData))
				return
			}
			
			if let token = String(data: data, encoding: .utf8) {
				self.secureData.setToken(value: token)
				completion(.success(token))
			} else {
				completion(.failure(.decoding))
			}
		}.resume()
	}
	
	func makeDataRequestfor<T: Decodable>(request: URLRequest, completion: @escaping (Result<[T], NetworkError>) -> Void) {
		
		session.dataTask(with: request) { data, response, error in
			
			guard let response = response as? HTTPURLResponse else {
				completion(.failure(.serverError))
				return
			}
			
			guard response.statusCode != 500 else { 
				completion(.failure(.serverError))
				return
			}

			guard response.statusCode != 401 else { 
					completion(.failure(.unauthorized))
				return
			}
			
			guard let data = data else { 
				completion(.failure(.noData))
				return
			}
			
			
			do {
				let dataReceived = try JSONDecoder().decode([T].self, from: data)
				completion(.success(dataReceived))
			} catch {
				completion(.failure(.decoding))
			}
			
		}.resume()
	}
}

