//
//  RestaurantDetailMapCell.swift
//  FavPlaces
//
//  Created by Magzhan Zhumaly on 29.11.2022.
//

import UIKit
import MapKit
 
class RestaurantDetailMapCell: UITableViewCell {
 
    @IBOutlet var mapView: MKMapView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    
    func configureByURL(location: String) {
        // Получение локации
        
        //        print("")
        
        var latitude = Double()
        var longitude = Double()
        
//        print("location = \(location)")
        if location != "nil" {
            let str = location
            let reversed = String(str.reversed())
            let ind = reversed.firstIndex(of: "/")
            let res = reversed.prefix(ind!.utf16Offset(in:str))
            
            let result = String(res)
            
            let fullStr = String(result.reversed())
            
            let indNew = fullStr.firstIndex(of: "%")
            let longitudeStr = fullStr.prefix(indNew!.utf16Offset(in:fullStr))
            
            let latitudeStr = fullStr.suffix(fullStr.count - indNew!.utf16Offset(in:fullStr) - 3)
            
            longitude = Double(String(longitudeStr)) ?? 0
            var latStr = String(latitudeStr)
            latStr.removeLast()
            
            latitude = Double(latStr) ?? 0
            
        }
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
        
        //        annotation1.title = self.restaurant.name
        //        annotation1.subtitle = self.restaurant.type
        
        
        self.mapView.addAnnotation(annotation1)
        
        self.mapView.showAnnotations([annotation1], animated: true)
        self.mapView.selectAnnotation(annotation1, animated: true)
        
        
        // Уровень зума
        let region = MKCoordinateRegion(center: annotation1.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        self.mapView.setRegion(region, animated: false)
    }
    
    func configureByLocation(location: String) {
        let geoCoder = CLGeocoder()

        print(location)
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
     
            if let placemarks = placemarks {
                let placemark = placemarks[0]
     
                // Добавление аннотации
                let annotation = MKPointAnnotation()
     
                if let location = placemark.location {
                    // Показ аннотации
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
     
                    // Уровень зума
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
     
        })
    }

 
}
