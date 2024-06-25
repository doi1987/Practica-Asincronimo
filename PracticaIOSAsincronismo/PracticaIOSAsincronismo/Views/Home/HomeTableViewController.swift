//
//  HomeTableViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import UIKit

final class HomeTableViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var tableViewOutlet: UITableView!
	@IBOutlet weak var loadingView: UIView!
	
	// MARK: - View Model
	private var homeViewModel: HomeViewModel
	
	// MARK: - Inits
	init(homeViewModel: HomeViewModel = HomeViewModel()) {
		self.homeViewModel = homeViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()	
		tableViewOutlet.delegate = self
		tableViewOutlet.dataSource = self
		tableViewOutlet.register(
			UINib(
				nibName: HeroTableViewCell.nibName, 
				bundle: nil), forCellReuseIdentifier: HeroTableViewCell.identifier)
		homeViewModel.loadHeroes()
		setObservers()
		setupNavigationBar()
    }
}

private extension HomeTableViewController {
	func setObservers(){
		homeViewModel.homeStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				self?.loadingView.isHidden = false
			case .loaded:
				self?.loadingView.isHidden = true
				self?.tableViewOutlet.reloadData()
			case .error(_):
				self?.loadingView.isHidden = true
			case .none:
				print("Home None")
			}
		}
	}
	
	func setupNavigationBar() {
		navigationController?.isNavigationBarHidden = false
		navigationItem.hidesBackButton = true
		navigationItem.title = "Lista Heroes"
		
		let item = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped(_:)))		
		navigationItem.rightBarButtonItem  = item
	}
	
	@objc func logoutTapped(_ sender: UIBarButtonItem) {
		homeViewModel.logout()
		navigationController?.popToRootViewController(animated: true)
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
