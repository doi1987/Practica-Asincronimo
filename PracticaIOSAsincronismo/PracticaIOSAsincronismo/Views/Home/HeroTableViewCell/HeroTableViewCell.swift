//
//  HeroTableViewCell.swift
//  PracticaIOSAsincronismo
//
//  Created by David Ortega Iglesias on 24/6/24.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
	static let nibName = "HeroTableViewCell"
	static let identifier = "heroTableViewIdentifier"
	
	@IBOutlet weak var heroImage: UIImageView!	
	@IBOutlet weak var heroName: UILabel!
	@IBOutlet weak var heroDescription: UILabel!	
	@IBOutlet weak var chevronImage: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.selectionStyle = .none
	}

	func configure(with hero: HeroModel) {
		heroName.text = hero.name
		heroDescription.text = hero.description
		heroImage.image = UIImage(named: "placeholder")

		guard let imageURLString = hero.photo,
			  let imageURL = URL(string: imageURLString) else {
			return
		}
		heroImage.setImage(url: imageURL)
	}
}
