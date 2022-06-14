//
//  ArtWork.swift
//  Mapas
//
//  Created by A1-IMAC06 on 26/1/22.
//

import Foundation
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation{
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String, locationName: String, discipline:String, coordinate:CLLocationCoordinate2D){
        
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        //Se pone el super.init para que herede el constructor del padre
        super.init()
    }
    
    
    var subtitle: String? {
        return locationName
    }
    
    //Funcioncalidad para abrir el maps al tocar en el accesorio
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.name = title
        return mapItem
    }
    
}
