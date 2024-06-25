//
//  TransformationDetailViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 27/1/24.
//

import UIKit

class TransformationDetailViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var transformationImage: UIImageView!	
	@IBOutlet weak var transformationName: UILabel!	
	@IBOutlet weak var transformationDescription: UILabel!
	
	// MARK: - Model
	private var transformationDetailViewModel: TransformationDetailViewModel
	
	// MARK: - Inits
	init(transformationDetailViewModel: TransformationDetailViewModel) {
		self.transformationDetailViewModel = transformationDetailViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
}

private extension TransformationDetailViewController {
	func setupView() {
		transformationName.text = transformationDetailViewModel.transformationDetail.name
		transformationDescription.text = transformationDetailViewModel.transformationDetail.description
		transformationImage.image = UIImage(named: "placeholder")
		
		guard let imageUrlString = transformationDetailViewModel.transformationDetail.photo,
			  let imageURL = URL(string: imageUrlString) else {
			return
		}
		transformationImage.setImage(url: imageURL)		
	}
}
