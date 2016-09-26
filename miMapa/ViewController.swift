//
//  ViewController.swift
//  miMapa
//
//  Created by Oscar Zarco on 19/09/16.
//  Copyright © 2016 oscarzarco. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var mapa: MKMapView!
    
    
    fileprivate let manejador = CLLocationManager()
    var contador : Double = 0.0
    fileprivate  var localizacionAnterior = CLLocation()
    //var puntoAnt = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            mapa.centerCoordinate = (manager.location?.coordinate)!
            
            let region = MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 2000, 2000)
            mapa.setRegion(region, animated: true)
        }
        else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var punto = CLLocationCoordinate2D()
        punto.latitude =  manager.location!.coordinate.latitude
        punto.longitude = manager.location!.coordinate.longitude
        
        
        
        if contador == 0 {
            let pin = MKPointAnnotation()
            pin.title = "Longitud: " + String(format: "%.4f" ,punto.longitude ) + " Latitud: " + String(format: "%.4f" ,punto.latitude)
            pin.subtitle = "Distancia: " + String(format: "%.2f",contador)
            pin.coordinate = punto
            mapa.addAnnotation(pin)
            
            localizacionAnterior = manager.location!
            contador = 0.0001
        }
        else {
            if manager.location?.distance(from: localizacionAnterior) >= 50 {
                contador = contador + (manager.location?.distance(from: localizacionAnterior))!
                localizacionAnterior = manager.location!
                
                let pin = MKPointAnnotation()
                pin.title = "Longitud: " + String(format: "%.4f" ,punto.longitude) + " Latitud: " + String(format: "%.4f" ,punto.latitude)
                pin.subtitle = "Distancia: " + String(format: "%.2f",contador)
                pin.coordinate = punto
                mapa.addAnnotation(pin)
                
            }
        }

        
    }
    
    
    
    @IBAction func standar() {
        mapa.mapType = MKMapType.standard
    }
    @IBAction func satelital() {
        mapa.mapType = MKMapType.satellite
    }
    @IBAction func hibrido() {
        mapa.mapType = MKMapType.hybrid
    }
    
    @IBAction func zoomMenos() {
        var region = mapa.region
        region.span.latitudeDelta = region.span.latitudeDelta * 2
        region.span.longitudeDelta = region.span.longitudeDelta * 2
        mapa.setRegion(region, animated: true)
    }

    @IBAction func zoomMas() {
        var region = mapa.region
        region.span.latitudeDelta = region.span.latitudeDelta/2.0
        region.span.longitudeDelta = region.span.longitudeDelta/2.0
        mapa.setRegion(region, animated: true)
    }
    
    @IBAction func zoomInOut(_ sender: UISlider) {
        //let ubicacion = mapa.userLocation
        
        //let region = MKCoordinateRegionMakeWithDistance((ubicacion.location?.coordinate)!, Double(sender.value), Double(sender.value))
        var region = mapa.region
        region.span.latitudeDelta = Double(sender.value)
        region.span.longitudeDelta = Double(sender.value)
        mapa.setRegion(region, animated: true)
    }
    
}

