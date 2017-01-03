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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    let model = PhotoModel.sharedInstance()
    
    var batch = [BlockOperation]()
    
    @IBOutlet weak var newCollectionButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCollectionButton.isEnabled = false
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
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            self.fetchPhotos()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
            
    }
    
    
    func fetchPhotos() {
        do {
                try fetchedResultsController.performFetch()
                newCollectionButton.isEnabled = true
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
         let counter = (fetchedResultsController.fetchedObjects?.count)!
        
        if counter > 0 {
      //      newCollectionButton.isEnabled = true
        } else {
            print("no images")
        }
        
         return counter
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell",
                                                      for: indexPath) as! PhotoCell
        
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        
        if photo.photo != nil {
           cell.loadImage(data: photo.photo!)
        } else {
    
            cell.loadImage(url: photo.url!) { success in
    
                if success {
                    if let data = UIImagePNGRepresentation(cell.image.image!) {
                        photo.photo = data as NSData?
                    }
                }
            }
        }
        

        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            case .insert:
                batch.append(
                    
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.insertItems(at: [newIndexPath!])
                        }
                    })
                )
                break;
            case .delete:
                batch.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.deleteItems(at: [indexPath!])
                        }
                    })
                )
                break;
            case .update:
                batch.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.reloadItems(at: [indexPath!])
                        }
                    })
                )

                break;
            case .move:
                break;
        }
    }
    
    
    @IBAction func getNewCollection(_ sender: UIButton) {
        
        clearPhotos()
        newCollectionButton.isEnabled = false
        reset()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        fetchedResultsController.managedObjectContext.delete(photo)
        
        
    }
    
    func clearPhotos() {
        
        for obj in fetchedResultsController.fetchedObjects! {
            fetchedResultsController.managedObjectContext.delete(obj as! Photo)
        }
        
        
        do {
            
         try fetchedResultsController.managedObjectContext.save()
        } catch {
            
        }
        
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.batch {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.batch.removeAll(keepingCapacity: false)
        })
    }
    
    
    deinit {
        for operation: BlockOperation in batch {
            operation.cancel()
        }
        
        batch.removeAll(keepingCapacity: false)
    }
    
    
}
