//
//  SermonMain.swift
//  Eclesia
//
//  Created by Selase Kwawu on 01/05/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import Foundation

class SermonModel {
    
    
    var fetchedSermon = [SermonModelData]()
    
    
    var seriesID: Int?
    
    
    func parseData(completion: @escaping (()->())) {

        let id = self.seriesID!
        
        print("Selase ID: \(id)")
        
        let url = "http://churchapp.dev/sermon/\(id)"
        var request = URLRequest(url: URL(string: url)!)
        
         print("Selase url: \(url)")
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
                        
                        
                        let sermonTitle = eachSermon["sermon_title"] as! String
                        let sermonSpeaker = eachSermon["speaker"] as! String
                        let categoryName = eachSermon["category_name"] as! String
                        let sermonDate = eachSermon["date"] as! String
                        let seriesName = eachSermon["series_name"] as! String
                        
                        
                        
                        var thumbnailURL = URL(fileURLWithPath: "https://68.media.tumblr.com/avatar_fb6652696991_128.png")
                        
                        if let thumbnail = eachSermon["thumbnail_image"] as? String, let url = URL(string: thumbnail) {
                            thumbnailURL = url
                        }
                        
                        let fullImageURL = URL(fileURLWithPath: "https://68.media.tumblr.com/avatar_fb6652696991_128.png")
                        
                        
                        
                        self.fetchedSermon.append(SermonModelData(sermonTitle: sermonTitle, sermonSpeaker: sermonSpeaker, categoryName: categoryName, sermonDate: sermonDate, seriesName: seriesName, thumbnailURL: thumbnailURL as URL, fullImageURL: fullImageURL as URL))
                        
                        
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



class SermonModelData {
 
    var sermonTitle: String?
    var sermonSpeaker: String?
    var categoryName: String?
    var SermonDate: String?
    var seriesName: String?
    var thumbnailURL: URL?
    var fullImageURL: URL?
    
    
    init(sermonTitle: String, sermonSpeaker: String, categoryName: String, sermonDate: String, seriesName: String, thumbnailURL: URL, fullImageURL: URL) {
        self.sermonTitle = sermonTitle
        self.sermonSpeaker = sermonSpeaker
        self.categoryName = categoryName
        self.SermonDate = sermonDate
        self.seriesName = seriesName
        self.thumbnailURL = thumbnailURL
        self.fullImageURL = fullImageURL
    }
    
}
