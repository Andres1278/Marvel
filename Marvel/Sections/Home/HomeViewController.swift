//
//  ViewController.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusActivityIndicator: UIActivityIndicatorView!
    
    var characters: [Character] = []
    let numberOfColumns: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"
        setUpUI()
        loadCharacters()
    }
    
    func setUpUI() {
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        guard let flowLayout = charactersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 13, bottom: 0, right: 13)
        flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        statusLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadCharacters)))
    }
    
    @objc func loadCharacters() {
        statusLabel.text = "Loading..."
        statusLabel.isUserInteractionEnabled = false
        CharacterManager.getAllCharacters { [weak self] (characters) in
            guard let self = self else { return }
            self.statusActivityIndicator.stopAnimating()
            guard let characters = characters else {
                self.statusLabel.isUserInteractionEnabled = true
                self.statusLabel.text = "It was a problem loading the information, please tap here to try again."
                return
            }
            self.statusStackView.isHidden = true
            self.characters = characters
            self.charactersCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharacterCollectionViewCell
        cell.configure(with: characters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = ((screenSize.width - (10 * (numberOfColumns - 1) ) - 30) / numberOfColumns) - 1
        return CGSize(width: cellWidth.rounded() , height: 1.6 * cellWidth.rounded())
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        guard let destinationViewController = mainStoyboard.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController else {
            print("Couldn't find the view controller")
            return}
        destinationViewController.character = characters[indexPath.row]
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}



