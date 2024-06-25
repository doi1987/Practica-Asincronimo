//
//  TransformationCollectionViewCell.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 12/6/24.
//

import UIKit

class TransformationCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "transformationCell"
	static let nibName = "TransformationCollectionViewCell"

	@IBOutlet weak var transformationName: UILabel!
	@IBOutlet weak var transformationImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		transformationImage.layer.cornerRadius = transformationImage.frame.size.height / 2
    }
	
	func configure(transformationModel: TransformationModel){
		transformationName.text = transformationModel.name
		guard let imageURLString = transformationModel.photo,
			  let imageURL = URL(string: imageURLString) else {
			return
		}
		transformationImage.setImage(url: imageURL)
	}
}
