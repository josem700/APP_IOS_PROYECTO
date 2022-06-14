//
//  MapaViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 4/5/22.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    let initalLocation = CLLocation(latitude: 38.095138, longitude: -3.6360437)
    let regionRadius:CLLocationDistance=2000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapa.delegate = self
        self.configureMap()
    }
    
    func configureMap(){
        mapa.delegate = self
        self.centerMapOnLocation(location: initalLocation)
        showArtworkOnMap()
        mapa.showsUserLocation = true
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapa.setRegion(coordinateRegion, animated: true)
    }
    
    func showArtworkOnMap(){
        
        let location = Artwork(title: "OH! CAKE", locationName: "Linares", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 38.095938, longitude: -3.635869))
        
        mapa.addAnnotation(location)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      
            location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }

 
}

extension MapaViewController{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Artwork else { return nil }
        
        let identifier = "marker"
        
        var view:MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            //Si estamos recicl ando el marker
            dequeuedView.annotation = annotation
            view = dequeuedView
        }else{
            //Si creamos un nuevo objeto Marker
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //Esto hace que nos muestre la tarjetita
            view.canShowCallout = true
            
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        
        return view
    }
}
