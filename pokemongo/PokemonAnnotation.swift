//
//  PokemonAnnotation.swift
//  pokemongo
//
//  Created by Pedro Vinicius Cuêlho do Nascimento on 14/02/2019.
//  Copyright © 2019 Pedro Nascimento. All rights reserved.
//

import MapKit
import UIKit

class PokemonAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon

    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }

}
