//
//  MapViewController.swift
//  FavPlaces
//
//  Created by Magzhan Zhumaly on 29.11.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var restaurant = Restaurant()
    
    var routeIsHidden = true
    var annotation1 = MKPointAnnotation()

    var annotationsArray = [MKPointAnnotation]()
    var minRoute = MKRoute()
    let citiesDict = [         "taraz" : "Тараз",
                               "almaty" : "Алматы",
                               "astana" : "Астана",
                               "shymkent" : "Шымкент",
                               "aktau" : "Актау",
                               "atyrau" : "Атырау",
                               "uralsk" : "Уральск",
                               "aktobe" : "Актобе",
                               "kyzylorda" : "Кызылорда",
                               "kostanay" : "Костанай",
                               "kokshetau" : "Кокшетау",
                               "petropavlovsk" : "Петропавловск",
                               "karaganda" : "Караганда",
                               "ustkam" : "Усть-Каменегорск",
                               "semey" : "Семей",
                               "pavlodar" : "Павлодар"
                               ]
//    let citiesDictReverse = [  "Тараз" : "taraz",
//                                "Алматы" : "almaty",
//                                "Астана" : "astana",
//                                "Шымкент" : "shymkent",
//                                "Актау" : "aktau",
//                                "Атырау" : "atyrau",
//                                "Уральск" : "uralsk",
//                                "Актобе" : "aktobe",
//                               "Кызылорда" : "kyzylorda",
//                               "Костанай" : "kostanay",
//                               "Кокшетау" : "kokshetau",
//                               "Петропавловск" : "petropavlovsk",
//                               "Караганда" : "karaganda",
//                               "Усть-Каменегорск" : "ustkam",
//                                "Семей" : "semey",
//                               "Павлодар" : "pavlodar"
//                               ]

    
    fileprivate let locationManager:CLLocationManager = CLLocationManager ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        mapView.showsUserLocation = true
        print("navigationItem = \(navigationItem)")
        mapView.delegate = self
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        // Преобразование адреса в координаты и аннотирование его на карте
        /*
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
         */
        
        if restaurant.url != "nil" {
            
            let str = restaurant.url ?? ""
            let reversed = String(str.reversed())
            let ind = reversed.firstIndex(of: "/")
            let res = reversed.prefix(ind!.utf16Offset(in:str))
            
            let result = String(res)
            
            let fullStr = String(result.reversed())
            
            let indNew = fullStr.firstIndex(of: "%")
            let longitudeStr = fullStr.prefix(indNew!.utf16Offset(in:fullStr))
            
            let latitudeStr = fullStr.suffix(fullStr.count - indNew!.utf16Offset(in:fullStr) - 3)
            
            let longitude = Double(String(longitudeStr)) ?? 0
            var latStr = String(latitudeStr)
            latStr.removeLast()
            
            let latitude = Double(latStr) ?? 0
            
            annotation1.coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
            
            annotation1.title = self.restaurant.name
            annotation1.subtitle = self.restaurant.type
            
            self.mapView.addAnnotation(annotation1)
            
            self.mapView.showAnnotations([annotation1], animated: true)
            self.mapView.selectAnnotation(annotation1, animated: true)
            
        } else {
            let geoCoder = CLGeocoder()

            let location = "\(citiesDict[restaurant.city] ?? ""), \(restaurant.location)"
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
        //        }
        
        //            self.mapView.showAnnotations([], animated: <#T##Bool#>)
        //            let annotation = MKPointAnnotation()
        //            annotation.title = self.restaurant.name
        //            annotation.subtitle = self.restaurant.type
        //
        //            if let location = placemark.location {
        //                annotation.coordinate = location.coordinate
        //
        //                // Отобразить аннотацию
        //                self.mapView.showAnnotations([annotation], animated: true)
        //                self.mapView.selectAnnotation(annotation, animated: true)
        //            }
        
        //        76.869944
        //        43.26688
        
        //        })
        
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: UIButton) {
        if routeIsHidden {
            createDirectRequest(startCoordinate: CLLocationCoordinate2D(latitude: 34.261756, longitude: -118.316245), destinationCoordinate: CLLocationCoordinate2D(latitude: 34.233377, longitude: -118.411902))

//            createDirectRequest(startCoordinate: mapView.userLocation.coordinate, destinationCoordinate: annotation1.coordinate)
            
            let userAnnotation = MKPointAnnotation()
            userAnnotation.title = "User"
            guard let placemarkLocation = mapView.userLocation.location else { return }
            userAnnotation.coordinate = placemarkLocation.coordinate
            
//            annotationsArray.append(userAnnotation)
//            annotationsArray.append(annotation1)
//
//            mapView.showAnnotations(annotationsArray, animated: true)
        } else {
            mapView.removeOverlays(mapView.overlays)
//            mapView.removeAnnotations(mapView.annotations)
//            annotationsArray = [MKPointAnnotation]()
        }
        routeIsHidden.toggle()
    }
     
    private func createDirectRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)

        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            if let error = error {
                print("ERROR OCCURRED")

                let alert = UIAlertController(title: String(localized: "Error"), message: String(localized: "Route unavailable"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                print(error)
                return
            }
            
            guard let response = response else {
                let alert = UIAlertController(title: String(localized: "Error"), message: String(localized: "Route unavailable"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
//            response.routes
            self.minRoute = response.routes[0]
            for route in response.routes {
                self.minRoute = (route.distance < self.minRoute.distance) ? route : self.minRoute
            }
            self.mapView.addOverlay(self.minRoute.polyline)

        }
    }
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer (overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}
