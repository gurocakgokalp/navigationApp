//
//  ViewController.swift
//  MapsUsage
//
//  Created by Gökalp Gürocak on 1.10.2025.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

//MKMapViewDelegate ve CLLocationManagerDelegate eklemeyi unutma!

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    

    var locationManager = CLLocationManager()
    
    var currentLatitude: Double = 0
    var currentLongitude: Double = 0
    var name: String = ""
    var desc: String = ""
    var gelenName: String = ""
    var gelenUUID = UUID()

    var annotationDesc = String()
    var annotationLongitude = Double()
    var annotationLatitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        //accuracy -> keskinlik, ne kadar yakın info alınmak isteniyor (doğru info)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if gelenName == ""{
            // add btn ile geldi
            print("add btn ile geldi")
            
            
        } else{
            //listView aracılığıyla geldi
            nameTextField.text = gelenName
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            fetchRequest.returnsObjectsAsFaults = false
            let id = gelenUUID.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            
            do {
                let sonuclar = try context.fetch(fetchRequest)
                for sonuc in sonuclar as! [NSManagedObject]{
                    if let desc = sonuc.value(forKey: "desc") as? String{
                        annotationDesc = desc
                        descTextField.text = desc
                    }
                    if let longitude = sonuc.value(forKey: "longitude") as? Double {
                        annotationLongitude = longitude
                    }
                    if let latitude = sonuc.value(forKey: "latitude") as? Double {
                        annotationLatitude = latitude
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = self.gelenName
                    annotation.subtitle = annotationDesc
                    let kordinat = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                    annotation.coordinate = kordinat
                
                    mapView.addAnnotation(annotation)
                    
                    //garanti olsun diye durduruyoruz. aslında zaten if ile koşul attık ama olsun
                    locationManager.stopUpdatingLocation()
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    let region = MKCoordinateRegion(center: kordinat, span: span)
                    mapView.setRegion(region, animated: true)
                    
                    nameTextField.isEnabled = false
                    descTextField.isEnabled = false
                        
                }
            } catch {
                
            }
        }
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectKonum(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            
            let btn = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = btn
            
        } else {
            print("else")
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    @objc func selectKonum(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began && gelenName == "" {
            let tappedDot = gestureRecognizer.location(in: mapView)
            //Tek olay burdaki noktayı koordinata çevirebilmek.
            let tappedLoc = mapView.convert(tappedDot, toCoordinateFrom: mapView)
            
            
            
            let annotation = MKPointAnnotation()
            if nameTextField.text == "" {
                annotation.title = "??"
                name = "??"
            }else{
                annotation.title = nameTextField.text
                name = nameTextField.text ?? "error"
            }
            if descTextField.text == "" {
                annotation.subtitle = "??"
                desc = "??"
            }else{
                annotation.subtitle = descTextField.text
                desc = descTextField.text ?? "error"
            }
            
            btnSave.isEnabled = true
            
            annotation.coordinate = tappedLoc
            
            currentLatitude = annotation.coordinate.latitude
            currentLongitude = annotation.coordinate.longitude
            
            mapView.addAnnotation(annotation)
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.gelenName == ""{
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)

            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let locations = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context)
        
        locations.setValue(self.name, forKey: "name")
        locations.setValue(self.desc, forKey: "desc")
        
        locations.setValue(UUID(), forKey: "id")
        locations.setValue(currentLatitude, forKey: "latitude")
        locations.setValue(currentLongitude, forKey: "longitude")
        
        
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("posted"), object: nil)
        } catch{
            print("something went wrong when context saving...")
        }
        print(self.name,self.desc,currentLatitude,currentLongitude)
    }
    

    

}

