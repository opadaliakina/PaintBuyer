//
//  PaintItem.swift
//  PaintBuyer
//
//  Created by Olga Padaliakina on 24.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation

struct PaintItem {
    
    enum Keys {
        static let name = "Name"
        static let width = "width"
        static let height = "height"
        static let url = "url"
        static let productId = "productId"
    }
    
    let url: String
    let width: Int
    let height: Int
    let name: String
    let productId: String
    
}
