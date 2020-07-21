//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Pedro Andres Villamil on 14/07/20.
//  Copyright © 2020 Pedro Andres Villamil. All rights reserved.
//

import UIKit
import SafariServices

class CharacterDetailViewController: UIViewController {

    enum Section: String {
        case comics
        case series
    }
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var character: Character?
    var tableSections: [Section] = [ .comics, .series]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureCharacter()
        // Do any additional setup after loading the view.
    }
    
    func configureCharacter() {
        guard let character = character else {
            return
        }
        guard let imageURL = character.thumbnail.url else { return }
        characterImageView.contentMode = .scaleToFill
        characterImageView.setImage(with: imageURL)
        characterNameLabel.text = character.name
        characterDescriptionLabel.text = character.description
    }
}

extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.headerView(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section].rawValue.capitalized
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let character = character else { return 0 }
        switch tableSections[section] {
        case .comics: return character.comics.items.count
        case .series: return character.series.items.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let character = character else { fatalError("[CharacterDetailViewController] character not set") }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var title = ""
        switch tableSections[indexPath.section] {
        case .comics: title = character.comics.items[indexPath.row].name
        case .series: title = character.series.items[indexPath.row].name
        }
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = character else { fatalError("[CharacterDetailViewController] character not set") }
        switch tableSections[indexPath.section] {
        case .comics:
            getURL(from: character.comics.items[indexPath.row].resourceURI )
        case .series:
            getURL(from: character.series.items[indexPath.row].resourceURI )
        }
        
    }
        
    func getURL(from URI: String) {
        CharacterManager.getURLs(from: URI) { (resourceURL) in
            guard let resource = resourceURL else { return }
            let filterURL = resource.urls.filter {$0.type == "detail"}
            guard let detailURL = filterURL.first, let url = URL(string: detailURL.url.replacingOccurrences(of: "http", with: "https")) else { return }
            self.presentBrower(with: url)
        }
    }
    
    func presentBrower(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
