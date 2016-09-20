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

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var mapa: MKMapView!
    
    
    private let manejador = CLLocationManager()
    var contador : Double = 0.0
    private  var localizacionAnterior = CLLocation()
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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
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

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
            if manager.location?.distanceFromLocation(localizacionAnterior) >= 50 {
                contador = contador + (manager.location?.distanceFromLocation(localizacionAnterior))!
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
        mapa.mapType = MKMapType.Standard
    }
    @IBAction func satelital() {
        mapa.mapType = MKMapType.Satellite
    }
    @IBAction func hibrido() {
        mapa.mapType = MKMapType.Hybrid
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
    
    @IBAction func zoomInOut(sender: UISlider) {
        //let ubicacion = mapa.userLocation
        
        //let region = MKCoordinateRegionMakeWithDistance((ubicacion.location?.coordinate)!, Double(sender.value), Double(sender.value))
        var region = mapa.region
        region.span.latitudeDelta = Double(sender.value)
        region.span.longitudeDelta = Double(sender.value)
        mapa.setRegion(region, animated: true)
    }
    
}

