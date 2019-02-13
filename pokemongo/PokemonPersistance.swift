//
//  PokemonPersistance.swift
//  pokemongo
//
//  Created by Pedro Vinicius Cuêlho do Nascimento on 12/02/2019.
//  Copyright © 2019 Pedro Nascimento. All rights reserved.
//

import UIKit
import CoreData

class PokemonPersistance {

    func getContext() -> NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            return context
        }

        return nil
    }

    func createAll() {
        create(name: "Abra",        imageName: "abra",          captured: false)
        create(name: "Bellsprout",  imageName: "bullbasaur",    captured: true)
        create(name: "Caterpie",    imageName: "caterpie",      captured: false)
        create(name: "Charmander",  imageName: "charmander",    captured: true)
        create(name: "Dratini",     imageName: "dratini",       captured: true)
        create(name: "Eevee",       imageName: "eevee",         captured: true)
        create(name: "Jigglypuff",  imageName: "jigglypuff" ,   captured: false)
        create(name: "Mankey",      imageName: "mankey",        captured: false)
        create(name: "Meowth",      imageName: "meowth",        captured: false)
        create(name: "Mew",         imageName: "mew",           captured: true)
        create(name: "Pidgey",      imageName: "pidgey",        captured: false)
        create(name: "Pikachu",     imageName: "pikachu-2",     captured: true)
        create(name: "Psyduck",     imageName: "psyduck",       captured: false)
        create(name: "Rattata",     imageName: "rattata",       captured: false)
        create(name: "Snorlax",     imageName: "snorlax",       captured: false)
        create(name: "Squirtle",    imageName: "squirtle",      captured: true)
        create(name: "Venonat", 	imageName: "venonat",       captured: false)
        create(name: "Weedle", 	    imageName: "weedle",        captured: false)
        create(name: "Zubat",       imageName: "zubat",         captured: false)
    }

    func create(name: String, imageName: String, captured: Bool) {
        if let context = getContext() {
            let pokemon = Pokemon(context: context)

            pokemon.name = name
            pokemon.imageName = imageName
            pokemon.captured = captured
        }
    }

    func addAll() -> [Pokemon] {
        let context = getContext()

        do {
            if let pokemon = try context?.fetch(Pokemon.fetchRequest()) as? [Pokemon] {

                if pokemon.count == 0 {
                    self.createAll()
                    return addAll()
                }

                return pokemon
            }


        } catch { }

        return []
    }
}
