//
//  CharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    func configure(with character: Character) {
        characterImageView.contentMode = .scaleAspectFill
        characterNameLabel.text = character.name
        guard let imageURL = character.thumbnail.url else { return }
        characterImageView.setImage(with: imageURL)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}
