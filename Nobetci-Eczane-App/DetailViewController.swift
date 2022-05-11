//
//  DetailViewController.swift
//  Nobetci-Eczane-App
//
//  Created by Eyüp Emre Aygün on 11.05.2022.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDist: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var nameString:String!
    var distString:String!
    var addressString:String!
    var phoneString:String!
    var locString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblAddress.numberOfLines = 0
                self.updateUI()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Yol Tarifi Al", style: .plain, target: self, action: #selector(rightHandAction))
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(leftHandAction))
                
                mapView.delegate = self
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
        //        41.839311,26.732826
                let base = locString.components(separatedBy: ",")
                let lat = Double(base[0])
                let lon = Double(base[1])
                
                let annotation = MKPointAnnotation()
        //        annotation.coordinate = CLLocationCoordinate2D(latitude: 41.67702, longitude: 26.55590)
                let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                annotation.coordinate = coordinate
                
                if nameString.hasSuffix("Sİ") || nameString.hasSuffix("SI")  == true {
                    annotation.title = "\(String(describing: nameString!.capitalized))"
                }
                else{
                    annotation.title = "\(String(describing: nameString!.capitalized)) Eczanesi"
                }
                
                annotation.subtitle = "+90\(phoneString!)"
                self.mapView.addAnnotation(annotation)
                
                locationManager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                mapView.setRegion(region, animated: true)
            }
            
            @objc
            func rightHandAction() {
                let corr = locString.components(separatedBy: ",")
                let lat = Double(corr[0])!
                let lon = Double(corr[1])!
                let requestLocation = CLLocation(latitude: lat, longitude: lon)
                
                CLGeocoder().reverseGeocodeLocation(requestLocation) { [self] (placemarks, error) in
                    
                    if let placemark = placemarks {
                        if placemark.count > 0 {
                            let newPlacemark = MKPlacemark(placemark: placemark[0])
                            let item = MKMapItem(placemark: newPlacemark)
                            item.name = "\(nameString!.capitalized) Eczanesi"
                            
                            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                            item.openInMaps(launchOptions: launchOptions)
                        }
                    }
                }
            }
            
            @objc
            func leftHandAction() {
                dismiss(animated: true, completion: nil)
            }
            
            func updateUI() {
                
                if nameString.hasSuffix("Sİ") || nameString.hasSuffix("SI")  == true {
                    self.lblName.text = "\(nameString!.capitalized)"
                }
                else{
                    self.lblName.text = "\(nameString!.capitalized) Eczanesi"
                }
                
                
                self.lblDist.text = distString.capitalized
                self.lblAddress.text = addressString.capitalized
                self.lblPhone.text = "+90\(phoneString!)"
            }
            
            
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
                let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView.setRegion(region, animated: true)
            }
            
            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                if annotation is MKUserLocation {
                    return nil
                }
                
                let annotationID = "anno1"
                var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) as? MKPinAnnotationView
                
                if pinView == nil {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
                    pinView?.canShowCallout = true
                    
                    let button = UIButton(type: UIButton.ButtonType.system)
                    pinView?.rightCalloutAccessoryView = button
                }
                else{
                    pinView?.annotation = annotation
                }
                
                return pinView
            }
        }

