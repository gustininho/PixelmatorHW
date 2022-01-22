//
//  PhotosNavigationController.swift
//  PixelmatorHW
//
//  Created by Gustas Dersonas on 2022-01-22.
//

import Foundation
import UIKit

class PhotosNavigationController: UINavigationController {
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbar.topItem?.title = "The best photo library ever!"
        navbar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

}
