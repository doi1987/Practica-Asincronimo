//
//  LoginController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit

final class LoginController: UIViewController {
	
	// MARK: - Outlets
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var errorEmail: UILabel!	
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var errorPassword: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var loginButton: UIButton!
	
	private let viewModel: LoginViewModel
	//	private let storeDataProvider: StoreDataProviderProtocol
	
	// MARK: - Inits
	init(viewModel: LoginViewModel = LoginViewModel()){//, storeDataProvider: StoreDataProviderProtocol) 
		self.viewModel = viewModel
		//		self.storeDataProvider = storeDataProvider
		super.init(nibName: String(describing: LoginController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Ocultamos el navigation bar porque no queremos tener opción de navegar Back
		navigationController?.isNavigationBarHidden = true
		addObservers()
		setupView()
	}
	
	func addObservers() {
		viewModel.loginStateChanged = { [weak self] state in
			switch state {
			case .success:
				self?.activityIndicator.stopAnimating()
				// Navegamos a Heroes Controller
				DispatchQueue.main.async {
					// Si el login es con exito, navegamos a la pantalla de Heroes
					let vc = HomeTableViewController()
					self?.navigationController?.pushViewController(vc, animated: true)
				}
			case .failed(_):
				self?.activityIndicator.stopAnimating()
				self?.showAlert()
			case .loading:
				self?.activityIndicator.startAnimating()
			case .showErrorEmail(let error):
				self?.errorEmail.text = error
				self?.errorEmail.isHidden = (error == nil || error?.isEmpty == true)
			case .showErrorPassword(let error):
				self?.errorPassword.text = error
				self?.errorPassword.isHidden = (error == nil || error?.isEmpty == true) 
			}
		}
	}
	
	// MARK: - Actions
	@IBAction func loginTapped(_ sender: Any) {
		guard let email = emailTextField.text,
			  let password = passwordTextField.text else { return }
		
		viewModel.loginWith(email: email, password: password )
	}
	
	@objc func validFields(_ textfield: UITextField) {
		loginButton.isEnabled = isEnabled()
		switch textfield.accessibilityIdentifier {
		case TextFieldType.email.rawValue:
			validEmail(textfield)
		case TextFieldType.password.rawValue:
			validPassword(textfield)
		default: return
		}
	}
	
	func validEmail(_ sender: UITextField) {
		guard let text = sender.text else { return }
		
		errorEmail.isHidden = viewModel.isValid(email: text)
	}
	
	func validPassword(_ sender: UITextField) {
		guard let text = sender.text else { return }
		
		errorPassword.isHidden = viewModel.isValid(password: text)
	}
}

private extension LoginController {
	func setupView() {
		emailTextField.accessibilityIdentifier = TextFieldType.email.rawValue
		emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
		passwordTextField.accessibilityIdentifier = TextFieldType.password.rawValue
		passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
		emailTextField.addTarget(self, action: #selector(validFields(_:)), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(validFields(_:)), for: .editingChanged)
		
		loginButton.backgroundColor = .systemBlue
		loginButton.layer.cornerRadius = 8
		
		#if DEBUG
		emailTextField.text = "davidortegaiglesias@gmail.com"
		passwordTextField.text = "abcdef"
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
		let alertController = UIAlertController(title: "Error", message: "El usuario o contraseña son incorrectos", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default)
		alertController.addAction(action)
		
		present(alertController, animated: true, completion: nil)
	}
}

enum TextFieldType: String {
	case email
	case password
}

