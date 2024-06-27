//
//  HomeTableViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import UIKit
import Combine

final class HomeTableViewController: UIViewController {

	@IBOutlet weak var tableViewOutlet: UITableView!
	@IBOutlet weak var loadingView: UIView!
	
	private var cancellables: Set<AnyCancellable> = .init()
	private var homeViewModel: HomeViewModel
	private var homeStatusLoad: StatusLoad?
	
	init(homeViewModel: HomeViewModel = HomeViewModel()) {
		self.homeViewModel = homeViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()	
		configureUI()
		setObservers()
		homeViewModel.loadHeroes()
    }
}

private extension HomeTableViewController {
	func setObservers(){
		homeViewModel.$homeStatusLoad
			.compactMap({ $0 })
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] state in 
				switch state {
				case .loaded:
					self?.loadingView.isHidden = true
					self?.tableViewOutlet.reloadData()	
				case .error(_): 
					self?.loadingView.isHidden = true
					self?.showAlert()
				case .loading:
					self?.loadingView.isHidden = false
				}
			}).store(in: &cancellables)
	}
	
	func configureUI() {
		setupNavigationBar()
		tableViewOutlet.delegate = self
		tableViewOutlet.dataSource = self
		tableViewOutlet.register(
			UINib(
				nibName: HeroTableViewCell.nibName, 
				bundle: nil), forCellReuseIdentifier: HeroTableViewCell.identifier)
	}
	
	func setupNavigationBar() {
		navigationController?.isNavigationBarHidden = false
		navigationItem.hidesBackButton = true
		navigationItem.title = "Heros List".localized()
		
		let item = UIBarButtonItem(title: "Logout".localized(), style: .plain, target: self, action: #selector(logoutTapped(_:)))		
		navigationItem.rightBarButtonItem  = item
	}
	
	@objc func logoutTapped(_ sender: UIBarButtonItem) {
		homeViewModel.logout()
		navigationController?.popToRootViewController(animated: true)
	}
	
	func showAlert() {
		let alertController = UIAlertController(title: "Error".localized(), message: "An error has occurred".localized(), preferredStyle: .alert)
		let action = UIAlertAction(title: "Retry".localized(), style: .default) {[weak self] _ in
			self?.homeViewModel.loadHeroes()
		}
		alertController.addAction(action)
		
		present(alertController, animated: true, completion: nil)
	}
}

// MARK: - Extension Delegate
extension HomeTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let nextVM = HeroDetailViewModel(hero: homeViewModel.dataHeroes[indexPath.row])
		let nextVC = HeroDetailViewController(heroDetailViewModel: nextVM)
			navigationController?.show(nextVC, sender: nil)
	}
}

// MARK: _ Extension DataSource
extension HomeTableViewController: UITableViewDataSource {
	// Numero de filas por seccion
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return homeViewModel.dataHeroes.count
	}
	
	// Formato de la celda
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: HeroTableViewCell.identifier, for: indexPath) as? HeroTableViewCell else { return UITableViewCell() }
		
		cell.configure(with: homeViewModel.dataHeroes[indexPath.row])
		return cell
	}
}
