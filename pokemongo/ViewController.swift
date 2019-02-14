//
//  ViewController.swift
//  pokemongo
//
//  Created by Pedro Vinicius Cuêlho do Nascimento on 11/02/2019.
//  Copyright © 2019 Pedro Nascimento. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!

    var locationManager: CLLocationManager!

    var pokemonPersistence: PokemonPersistance!
    var pokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        pokemonPersistence = PokemonPersistance()
        pokemon = pokemonPersistence.getAll()

        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            if let coordinate = self.locationManager.location?.coordinate {
                let totalPokemon = UInt32(self.pokemon.count)
                let randomPokemonIndex = Int(arc4random_uniform(totalPokemon))

                let pokemon = self.pokemon[randomPokemonIndex]

                let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)

                let randomLat = (Double(arc4random_uniform(175)) - 150) / 10000.0
                let randomLon = (Double(arc4random_uniform(175)) - 150) / 10000.0

                annotation.coordinate.latitude += randomLat
                annotation.coordinate.longitude += randomLon

                self.mapView.addAnnotation(annotation)
            }

        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            let alert = UIAlertController(title: "Atenção", message: "Acesse as configurações para habilitar o uso da localização.", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let goToSettingsAction = UIAlertAction(title: "Configurações", style: .default) { action in
                if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }

            alert.addAction(cancelAction)
            alert.addAction(goToSettingsAction)

            present(alert, animated: true, completion: nil)
        }
    }

    func centerPlayer() {
        if let coordinates = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinates, 500, 500)

            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerPlayer()
        locationManager.stopUpdatingLocation()
    }

    @IBAction func centerTrainer(_ sender: UIButton) {
        centerPlayer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)

        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        } else {
            if let pokemonAnnotation = annotation as? PokemonAnnotation {
                if let imageName = pokemonAnnotation.pokemon.imageName {
                    annotationView.image = UIImage(named: imageName)
                }
            }
        }
        
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40

        annotationView.frame = frame

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation

        mapView.deselectAnnotation(annotation, animated: true)

        if annotation is MKUserLocation { return }

        if let annotationCoordinate = annotation?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(annotationCoordinate, 200, 200)
            mapView.setRegion(region, animated: true)
        }

        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let userCoordinate = self.locationManager.location?.coordinate {
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(userCoordinate)) {
                    let pokemon = (annotation as! PokemonAnnotation).pokemon
                    self.pokemonPersistence.save(pokemon: pokemon)
                } else {
                    print("You are far away from the Pokemon. Aproach it and try again")
                }
            }
        }
    }
}

