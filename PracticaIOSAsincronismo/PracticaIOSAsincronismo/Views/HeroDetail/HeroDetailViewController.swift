//
//  HeroDetailViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import UIKit
import MapKit
import CoreLocation

class HeroDetailViewController: UIViewController {
	// MARK: - Outlets
	
	@IBOutlet weak var heroName: UILabel!	
	@IBOutlet weak var heroDescription: UITextView!
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var transformationCollectionView: UICollectionView!
	
	// MARK: - Properties -
	private let heroDetailViewModel: HeroDetailViewModel
	private let locationManager = CLLocationManager()
	
	init(heroDetailViewModel: HeroDetailViewModel) {
		self.heroDetailViewModel = heroDetailViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureUI() {
		transformationCollectionView.register(UINib(nibName: TransformationCollectionViewCell.nibName,
													bundle: nil), forCellWithReuseIdentifier: TransformationCollectionViewCell.identifier)
		transformationCollectionView.dataSource = self
		transformationCollectionView.delegate = self
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setObservers()
		configureUI()
		heroDetailViewModel.loadDetail()
	}
}

private extension HeroDetailViewController {
	func setObservers(){
		heroDetailViewModel.heroDetailStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				self?.loadingView.isHidden = false
			case .loaded:
				self?.loadingView.isHidden = true
				self?.setupView()
			case .error(_):
				self?.loadingView.isHidden = true
			case .none:
				print("Hero Detail None")
			}
		}
	}
	
	func setupView() {
		heroName.text = heroDetailViewModel.getHero()?.name
		heroDescription.text = heroDetailViewModel.getHero()?.description
		transformationCollectionView.reloadData()
	}
}

extension HeroDetailViewController: UICollectionViewDataSource,
									UICollectionViewDelegate,
									UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, 
						numberOfItemsInSection section: Int) -> Int {
		return heroDetailViewModel.getTransformations().count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationCollectionViewCell.identifier,
													  for: indexPath) as! TransformationCollectionViewCell
		cell.configure(transformationModel: heroDetailViewModel.getTransformations()[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let transformation = heroDetailViewModel.getTransformations()[indexPath.row]
		let viewModel = TransformationDetailViewModel(transformationDetail: transformation)
		let detailvc = TransformationDetailViewController(transformationDetailViewModel: viewModel)
		
		navigationController?.present(detailvc, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(width: collectionView.bounds.size.width / 3, height: collectionView.bounds.size.height)
	}
}
