//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/22/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    let photoModel = PhotoModel.sharedInstance()
    var selectedAnnotation:MKAnnotation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let press = UILongPressGestureRecognizer(target: self, action: #selector(onPress))
        map.addGestureRecognizer(press)
        
        getPins()
        // Do any additional setup after loading the view.
    }
    
    func getPins() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let pinSort = NSSortDescriptor(key: "latitude", ascending: true)
        request.sortDescriptors = [pinSort]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        
        do {
            try fetchedResultsController.performFetch()
            addPins(frc: fetchedResultsController)
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    func addPins(frc: NSFetchedResultsController<NSFetchRequestResult>) {
        
        for item in frc.fetchedObjects! {
            
            
            let item = item as! Pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(item.latitude), longitude: CLLocationDegrees(item.longitude))
            print(item.latitude)
            print(item.longitude)
            map.addAnnotation(annotation)
            
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func onPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: map)
            let coordinate = map.convert(location, toCoordinateFrom: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            map.addAnnotation(annotation)
            photoModel.getPhotos(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation
        performSegue(withIdentifier: "seePhotos", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seePhotos", let annotation = selectedAnnotation {
            
            let controller = segue.destination as! PhotoCollectionView
            controller.latitude = annotation.coordinate.latitude
            controller.longitude = annotation.coordinate.longitude
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
