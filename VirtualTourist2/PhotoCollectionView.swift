//
//  PhotoCollectionView.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/28/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotoCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        addPin()
        // Do any additional setup after loading the view.
    }
    
    private func addPin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!), CLLocationDegrees(longitude!))
        map.addAnnotation(annotation)
        map.setRegion(MKCoordinateRegion.init(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05,longitudeDelta: 0.05)), animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset() {
        PhotoModel.sharedInstance().getPhotos(latitude: latitude!, longitude: longitude!)
        fetchPhotos()
    }
    
    
    func fetchPhotos() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let photoSort = NSSortDescriptor(key: "url", ascending: true)
        request.sortDescriptors = [photoSort]
        let epsilon = 0.000001
        request.predicate = NSPredicate(format: "(%K BETWEEN {\(latitude! - epsilon), \(latitude! + epsilon) }) AND (%K BETWEEN {\(longitude! - epsilon), \(longitude! + epsilon) })", "pin.latitude", "pin.longitude")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        fetchPhotos()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell",
                                                      for: indexPath) as! PhotoCell
        
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        
        if photo.photo != nil {
            cell.loadImage(filename: photo.photo!) { success in
                
            }
            
        } else {
            
            
            cell.loadImage(url: photo.url!) { success in
                
                func getDocumentsDirectory() -> NSString {
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let documentsDirectory = paths[0]
                    return documentsDirectory as NSString
                }
                
                //Below function is used in imagePickerController
                
                if let data = UIImagePNGRepresentation(cell.image.image!) {
                    let filename = "\(NSDate()).png"
                    let path = getDocumentsDirectory().appendingPathComponent(filename)
                    do {
                        try data.write(to: URL(string: path)!, options: Data.WritingOptions.atomicWrite)
                    } catch {
                        
                    }
                    
                    photo.photo = filename
                }
            }
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        cell.isSelected = true
        
        //let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        
    }
    
    
    
    
}
