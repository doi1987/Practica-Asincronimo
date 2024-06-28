//
//  SplashViewController.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import UIKit

final class SplashViewController: UIViewController {
	
	@IBOutlet weak var splashActivityIndicator: UIActivityIndicatorView!
	
	private var secureData: SecureDataProtocol
	
	init(secureData: SecureDataProtocol = SecureDataKeychain()) {
		self.secureData = secureData
		super.init(nibName: String(describing: SplashViewController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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

