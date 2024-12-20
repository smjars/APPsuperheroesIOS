//
//  SuperheroListViewController.swift
//  APPsuperheroesIOS
//
//  Created by Tardes on 19/12/24.
//

import UIKit

struct Superhero: Codable {
    let id: Int
    let name: String
    let images: Images

    struct Images: Codable {
        let xs: String
        let sm: String
        let md: String
        let lg: String
    }
}

class SuperheroListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var superheroes: [Superhero] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchSuperheroes()
    }

    func fetchSuperheroes() {
        let urlString = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                self.superheroes = try JSONDecoder().decode([Superhero].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}

extension SuperheroListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superheroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuperheroCell", for: indexPath) as? SuperheroTableViewCell else {
            return UITableViewCell()
        }
        let superhero = superheroes[indexPath.row]
        cell.nameLabel.text = superhero.name
        if let url = URL(string: superhero.images.sm) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    cell.superheroImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: self)
        // Navegar a la vista de detalles
    }

    // Agrega este método para ajustar la altura de las celdas
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183 // Establece la altura de la celda, puedes ajustar este valor según sea necesario
    }
}
