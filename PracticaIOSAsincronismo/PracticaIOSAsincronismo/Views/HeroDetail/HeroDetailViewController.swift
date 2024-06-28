//
//  HeroDetailViewController.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import UIKit
import Combine

class HeroDetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var heroName: UILabel!	
	@IBOutlet weak var heroDescription: UITextView!
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var transformationsTitle: UILabel!
	@IBOutlet weak var transformationCollectionView: UICollectionView!
	
	private let heroDetailViewModel: HeroDetailViewModel
	private var cancellables: Set<AnyCancellable> = .init()
	private var heroDetailStatusLoad: StatusLoad?
	
	init(heroDetailViewModel: HeroDetailViewModel) {
		self.heroDetailViewModel = heroDetailViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setObservers()
		setupView()
		configureUI()
		heroDetailViewModel.loadTransformations()
	}
}

private extension HeroDetailViewController {
	func setObservers(){
		heroDetailViewModel.$heroDetailStatusLoad
			.compactMap({ $0 })
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] state in 
				switch state {
				case .loaded:
					self?.loadingView.isHidden = true
					self?.renderTransformations()
				case .error(_): 
					self?.loadingView.isHidden = true
				case .loading:
					self?.loadingView.isHidden = false
				}
			}).store(in: &cancellables)
	}	
	
	func configureUI() {
		transformationCollectionView.register(UINib(nibName: TransformationCollectionViewCell.nibName,
													bundle: nil), forCellWithReuseIdentifier: TransformationCollectionViewCell.identifier)
		transformationCollectionView.dataSource = self
		transformationCollectionView.delegate = self
	}
	
	func setupView() {
		heroName.text = heroDetailViewModel.getHero()?.name
		heroDescription.text = heroDetailViewModel.getHero()?.description
		transformationsTitle.text = "Transformations".localized()
		
		guard let urlImage = heroDetailViewModel.getHero()?.photo,
			  let url = URL(string: urlImage) else {
			imageView.image = UIImage(named: "noImage")
			return
		} 
		
		imageView.setImage(url: url)
	}
	
	func renderTransformations() {
		transformationsTitle.isHidden = heroDetailViewModel.getTransformations().isEmpty
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
