//
//  ViewController.swift
//  PaintBuyer
//
//  Created by Olga Padaliakina on 24.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var paintings: [PaintItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPaintings()
        
        if (self.collectionView.collectionViewLayout as? CustomCollectionLayout) == nil {
            let layout = CustomCollectionLayout.init()
            
            layout.delegate = self
            layout.columnCount = 2
            
            self.collectionView.collectionViewLayout = layout
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: -
    
    private func loadPaintings() {
        guard let path = Bundle.main.path(forResource: "Paints", ofType: "plist") else { return }
        
        guard let plistData = FileManager.default.contents(atPath: path) else { return }
        
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        guard let plistArray = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [[String : AnyObject]] else { return }
        
        for dict in plistArray {
            let url = dict[PaintItem.Keys.url] as! String
            let width = dict[PaintItem.Keys.width] as! Int
            let height = dict[PaintItem.Keys.height] as! Int
            let name = dict[PaintItem.Keys.name] as! String
            let productId = dict[PaintItem.Keys.productId] as! String
            
            let newPaint = PaintItem.init(url: url, width: width, height: height, name: name, productId: productId)
            self.paintings.append(newPaint)
        }
    }
    
    // MARK: -
    
    private func countSize(for item: PaintItem) -> CGSize {
        let finalWidth: CGFloat = self.view.frame.size.width / 2 - 20
        
        let width = CGFloat(item.width)
        let height = CGFloat(item.height)
        
        let k = finalWidth / width
        let finalHeight = k * height
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.paintings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaintCell", for: indexPath) as? PaintCell else {
            return UICollectionViewCell()
        }
        cell.configure(for: self.paintings[indexPath.row])
        return cell
    }
}

extension ViewController : CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paint = self.paintings[indexPath.row]
        return self.countSize(for: paint)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 15, 10, 10)
    }
}
