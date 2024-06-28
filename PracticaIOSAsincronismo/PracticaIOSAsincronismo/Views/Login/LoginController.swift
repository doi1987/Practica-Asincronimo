//
//  LoginController.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import UIKit
import Combine
import CombineCocoa

final class LoginController: UIViewController {
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var errorEmail: UILabel!	
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var errorPassword: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var loginButton: UIButton!
	
	private let viewModel: LoginViewModel
	private var cancellables: Set<AnyCancellable> = .init()
	private var user: String = ""
	private var password: String = ""
	
	init(viewModel: LoginViewModel = LoginViewModel()){
		self.viewModel = viewModel
		super.init(nibName: String(describing: LoginController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
		setupView()
		addObservers()
	}
	
	func addObservers() {
		viewModel.$loginState
			.receive(on: DispatchQueue.main)
			.compactMap({ $0 })
			.sink(receiveValue: { [weak self] state in 
				
			switch state {
			case .success:
				self?.activityIndicator.stopAnimating()
				let vc = HomeTableViewController()
				self?.navigationController?.pushViewController(vc, animated: true)
			case .failed(_):
				self?.activityIndicator.stopAnimating()
				self?.showAlert()
			case .loading:
				self?.activityIndicator.startAnimating()
			case .showErrorEmail(let error):
				self?.activityIndicator.stopAnimating()
				self?.errorEmail.text = error
				self?.errorEmail.isHidden = (error == nil || error?.isEmpty == true)
			case .showErrorPassword(let error):
				self?.activityIndicator.stopAnimating()
				self?.errorPassword.text = error
				self?.errorPassword.isHidden = (error == nil || error?.isEmpty == true) 
			}
		}).store(in: &cancellables)
		
		emailTextField.textPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] text  in
				guard let self = self,
					  let text = text else { return }
				self.user = text
			}
			.store(in: &cancellables)
		
		passwordTextField.textPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] text  in
				guard let self = self,
					  let text = text else { return }
				self.password = text
			}.store(in: &cancellables)
				
		loginButton.tapPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self = self else { return }
				
				self.viewModel.onLoginButton(email: self.user, password: self.password )
			}
			.store(in: &cancellables)
	}
}

private extension LoginController {
	func setupView() {
		emailTextField.accessibilityIdentifier = TextFieldType.email.rawValue
		emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
		passwordTextField.accessibilityIdentifier = TextFieldType.password.rawValue
		passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
		
		loginButton.backgroundColor = .systemBlue
		loginButton.layer.cornerRadius = 8
		
		#if DEBUG
		self.user = "davidortegaiglesias@gmail.com"
		emailTextField.text = user
		self.password =  "abcdef"
		passwordTextField.text = password
		#endif
	}
	
	func isEnabled() -> Bool {
		guard let email = emailTextField.text,
			  let password = passwordTextField.text else { return false }
		
		let enabled = !email.isEmpty && !password.isEmpty
		loginButton.backgroundColor = enabled ? UIColor.systemBlue : UIColor.systemGray		
		return enabled
	}
	
	func showAlert() {
		let alertController = UIAlertController(title: "Error", message: "Incorrect user or password".localized(), preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default)
		alertController.addAction(action)
		
		present(alertController, animated: true, completion: nil)
	}
}

enum TextFieldType: String {
	case email
	case password
}

