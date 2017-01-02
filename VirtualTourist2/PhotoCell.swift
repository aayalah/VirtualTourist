//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/28/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var chosen = false
    
    @IBOutlet weak var placeholder: UIView!
    
    
    func loadImage(url: String, completionHandler: @escaping (_ success:Bool) -> Void) {
         startLoading()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            
            
            do {
                
                let url = URL(string: url)!
                let data = try Data(contentsOf: url)
                
                
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.image.image = UIImage(data: data)
                    
                    completionHandler(true)
                }
            } catch {
                completionHandler(false)
            }
        })
    }
    
    func startLoading() {
        indicator.startAnimating()
        
    }
    
    func stopLoading() {
        indicator.stopAnimating()
        indicator.isHidden = true
        placeholder.isHidden = true
        image.isHidden = false
    }
    
    func loadImage(filename: String) {         
            let path = getDocumentsDirectory().appendingPathComponent(filename)
            self.image.image = UIImage(contentsOfFile: path)
        
    }
    
    private func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
}
