//
//  PaintCell.swift
//  PaintBuyer
//
//  Created by Olga Padaliakina on 24.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class PaintCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceView: PentagonView!
    
    var borderlayer = CAShapeLayer()
    var paintItem: PaintItem?
    
    func configure(for paint: PaintItem) {
        self.paintItem = paint
        
        if self.layer.sublayers?.contains(borderlayer) == true {
            borderlayer.removeFromSuperlayer()
        }
        borderlayer.strokeColor = UIColor.main.cgColor
        borderlayer.lineDashPattern = [8, 8]
        borderlayer.frame = self.bounds
        borderlayer.fillColor = nil
        let rect = self.bounds.insetBy(dx: 2, dy: 2)
        borderlayer.path = UIBezierPath(rect: rect).cgPath
        borderlayer.lineWidth = 2
        self.layer.addSublayer(borderlayer)
        
        self.nameLabel.textColor = .main
        self.nameLabel.text = paint.name
        self.downloadImage(urlString: paint.url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPrice(_:)), name: Notification.Name.init(paint.productId), object: nil)
    }
    
    fileprivate func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            
            DispatchQueue.main.async { [unowned self] in
                self.imageView.image = image
                self.borderlayer.removeFromSuperlayer()
                self.priceView.isHidden = false
                
                if let paint = self.paintItem {
                    IAPHandler.shared.fetchProduct(withId: paint.productId)
                }
            }
        }
    }
    
    @objc fileprivate func setPrice(_ notification: NSNotification) {
        guard let price = notification.object as? String else {
            return
        }
        let result = price.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
        if Double(result) == 0.0 {
            self.priceLabel.text = "FREE"
            self.priceView.pathColor = .main
            self.priceView.setNeedsDisplay()
            return
        }
        self.priceLabel.text = price
    }
}
