//
//  SuperheroDetailViewController.swift
//  APPsuperheroesIOS
//
//  Created by Tardes on 20/12/24.
//

import UIKit

class SuperheroDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var superhero: Superhero?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let superhero = superhero {
            nameLabel.text = superhero.name
            if let url = URL(string: superhero.images.lg) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
    }
}
