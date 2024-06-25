//
//  SplashViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit

// Pantalla que aplica la lógica para mostrar la pantalla de login o Heroes

class SplashViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var splashActivityIndicator: UIActivityIndicatorView!
	
	private var secureData: SecureDataProtocol
	
	// MARK: - Inits
	init(secureData: SecureDataProtocol = SecureDataKeychain()) {
		self.secureData = secureData
		super.init(nibName: String(describing: SplashViewController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		var vc: UIViewController
		if let _ = secureData.getToken() {
			vc = HomeTableViewController()
		} else {
			vc = LoginController()
		}
		navigationController?.pushViewController(vc, animated: false)
	}
}

