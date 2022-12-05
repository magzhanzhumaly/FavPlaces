//
//  MapViewController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 29.11.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
     
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("navigationItem = \(navigationItem)")
        mapView.delegate = self
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true

        // Преобразование адреса в координаты и аннотирование его на карте
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
     
            if let placemarks = placemarks {
                // Получение первой метки
                let placemark = placemarks[0]
     
                // Добавить аннотацию
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
     
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
     
                    // Отобразить аннотацию
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
     
        })
     
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapViewController: MKMapViewDelegate {
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
 
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
 
        // Повторное использование аннотации, если это возможно
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
 
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
 
//        annotationView?.glyphText = "&#x1f60b;"
        annotationView?.glyphText = "🍔"

        annotationView?.markerTintColor = UIColor(named: Colors.accentColor.rawValue)
 
        return annotationView
    }
}
