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
    var chosen = false
    
    func loadImage(url: String, completionHandler: @escaping (_ success:Bool) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            
            
            do {
                let url = URL(string: url)!
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    
                    self.image.image = UIImage(data: data)
                    completionHandler(true)
                }
            } catch {
                completionHandler(false)
            }
        })
    }
    
    
    func loadImage(filename: String, completionHandler: @escaping (_ success:Bool) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            
            
            
        })
        
        
        
        
    }
    
    
}
