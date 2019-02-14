//
//  PokedexViewController.swift
//  pokemongo
//
//  Created by Pedro Vinicius Cuêlho do Nascimento on 14/02/2019.
//  Copyright © 2019 Pedro Nascimento. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    var capturedPokemon: [Pokemon] = []
    var notCapturedPokemon: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let pokemonPersistance = PokemonPersistance()

        capturedPokemon = pokemonPersistance.get(captured: true)
        notCapturedPokemon = pokemonPersistance.get(captured: false)
    }

    @IBAction func backToMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension PokedexViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return capturedPokemon.count
        case 1:
            return notCapturedPokemon.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Capturados"
        case 1:
            return "Não capturados"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") {
            var pokemon: Pokemon!

            switch indexPath.section {
            case 0:
                pokemon = capturedPokemon[indexPath.row]
            case 1:
                pokemon = notCapturedPokemon[indexPath.row]
            default: break
            }

            cell.textLabel?.text = pokemon.name
            cell.imageView?.image = UIImage(named: pokemon.imageName!)

            return cell
        }

        return UITableViewCell()
    }

}
