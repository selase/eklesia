//
//  SermonCell.swift
//  Eclesia
//
//  Created by Selase Kwawu on 29/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit

class SermonCell: UITableViewCell {

    @IBOutlet weak var speakerLabel: UILabel!
    
    @IBOutlet weak var seriesLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sermonDateLabel: UILabel!
    @IBOutlet weak var sermonLabel: UILabel!
    
    @IBOutlet weak var sermonTitle: UILabel!
    @IBOutlet weak var sermonSpeaker: UILabel!
    @IBOutlet weak var sermonCategory: UILabel!
    
  
    var sermon: SermonModelData!{
        didSet {
            
            //print("Sermon from cell: \(sermon)")
            
            sermonSpeaker.text = sermon.sermonSpeaker
            sermonTitle.text = sermon.sermonTitle
            sermonCategory.text = sermon.categoryName
            
            seriesLabel.text = sermon.seriesName
            
            sermonCategory.text = "Category: \(sermon.categoryName ?? "No Category")"
            
            if let url = sermon.thumbnailURL {
                NetworkService(url: url).downloadImage({ (data) in
                    if let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            self.thumbnailImageView.image = image
                        }
                        
                    }
                })
            }
            
            
            
        }
    }
    
    var series: SermonData! {
        didSet {
            sermonCategory.text = "Category: \(sermon.categoryName ?? "No Category")"
            
            if let url = series.thumbnailURL {
                NetworkService(url: url).downloadImage({ (data) in
                    if let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            self.thumbnailImageView.image = image
                        }
                        
                    }
                })
            }
        }
    }
    
    
    func imageForRating(rating:Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }

}
