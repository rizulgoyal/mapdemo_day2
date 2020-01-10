//
//  ViewController.swift
//  mapdemo_day2
//
//  Created by Rizul goyal on 2020-01-10.
//  Copyright © 2020 Rizul goyal. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    let places = Place.getPlaces()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        addAnnotations()
        addPolyLine()
        addPolygon()
    //    locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
        
    }
    
    func addAnnotations()
    {
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        let overlays = places.map{(MKCircle(center: $0.coordinate, radius: 1000))}
        mapView.addOverlays(overlays)
    }
    
    func addPolyLine()
    {
        let locations = places.map{$0.coordinate}
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
    }
    func addPolygon()
    {
        let locations = places.map{$0.coordinate}
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        mapView.addOverlay(polygon)
    }


}

extension ViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        else
        {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place_2x")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
   // this func is needed  to add the overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }
        else if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        else if overlay is MKPolygon{
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.orange.withAlphaComponent(0.4)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title else {
            return
        }
        let alertControl = UIAlertController(title: "Welcome to \(title)", message: "Have a glood time in \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertControl.addAction(cancelAction)
        present(alertControl, animated: true, completion: nil)
    }
}

