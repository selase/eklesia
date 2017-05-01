//
//  PlayerCellTableViewCell.swift
//  Eclesia
//
//  Created by Selase Kwawu on 26/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit

class SeriesCell: UITableViewCell {
    
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sermonDateLabel: UILabel!
    

    var series: SermonData! {
        didSet {
            speakerLabel.text = series.speaker
            seriesLabel.text = series.series?.uppercased()

            categoryLabel.text = "Category: \(series.category ?? "No Category")"
            
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
