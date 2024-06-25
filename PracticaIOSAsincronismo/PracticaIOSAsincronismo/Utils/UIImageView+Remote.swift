//
//  UIImageView+Remote.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import UIKit

extension UIImageView {
	func setImage(url: URL) {
		downloadWithURLSession(url: url) { [weak self] image in
			DispatchQueue.main.async {
				self?.image = image
			}
		}
	}

	private func downloadWithURLSession(
		url: URL,
		completion: @escaping (UIImage?) -> Void
	) {
		URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			guard error == nil else {
				completion(UIImage(named: "noImage"))
				return
			}

			guard let data, let image = UIImage(data: data) else {
				completion(UIImage(named: "noImage"))
				return
			}

			completion(image)
		}
		.resume()
	}
}
