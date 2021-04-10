//
//  Picture.swift
//  BasicCameraPickerPractice
//
//  Created by Geoffry Gambling on 4/10/21.
//

import Foundation

class Picture: Codable {
    var image: String
    var imageCaption: String
    
    
    init(image: String, imageCaption: String) {
        self.image = image
        self.imageCaption = imageCaption
    }
    
}
