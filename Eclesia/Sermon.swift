//
//  SermonData.swift
//  Eclesia
//
//  Created by Selase Kwawu on 26/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import Foundation
import UIKit

class Sermon {
    
    
    var fetchedSermon = [SermonData]()
 
    
    func parseData(route: String, completion: @escaping (()->())) {
        
        
        
        
        let url = "http://churchapp.dev/series&sermon"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request){ (data, response, error) in
            
            if(error != nil){
                print("Error")
                completion()
            }else {
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
          
                    
                    for eachFetchedSermon in fetchedData {
                        
                
                        let eachSermon = eachFetchedSermon as! [String: Any]

                        let seriesId = eachSermon["id"] as! Int
                        let title = eachSermon["series_title"]! as! String
                        let series = eachSermon["series_name"]! as! String
                        
                        let speaker = eachSermon["speaker"] as! String
                        let category = eachSermon["category_name"] as! String
                        let date = eachSermon["date"] as! String
                        
                        
                        
                        var thumbnailURL = URL(fileURLWithPath: "https://68.media.tumblr.com/avatar_fb6652696991_128.png")

                        if let thumbnail = eachSermon["thumbnail_image"] as? String, let url = URL(string: thumbnail) {
                            thumbnailURL = url
                        }
                        
                        let fullImageURL = URL(fileURLWithPath: "https://68.media.tumblr.com/avatar_fb6652696991_128.png")
                        


                        self.fetchedSermon.append(SermonData(seriesId: seriesId, title: title, series: series, speaker: speaker, category: category, date: date, thumbnailURL: thumbnailURL as URL, fullImageURL: fullImageURL as URL))


                    }
                    
                    
                }
                catch{
                    
                    print("Error 2")
                }
                completion()
            }

        }
        task.resume()
        
        
        
    }
    
    
    
    
   
}



class SermonData {
    
    var title: String?
    var series: String?
    var speaker: String?
    var category: String?
    var date: String?
    var thumbnailURL: URL?
    var fullImageURL: URL?
    var seriesId: Int?

    
    
    init(seriesId: Int, title: String, series: String, speaker: String, category: String, date: String, thumbnailURL: URL, fullImageURL: URL) {
        self.title = title
        self.seriesId = seriesId
        self.series = title
        self.category = category
        self.date = date
        self.thumbnailURL = thumbnailURL
        self.fullImageURL = fullImageURL
        self.speaker = speaker
    }
    


}

