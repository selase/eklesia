//
//  RecordingViewController.swift
//  Eclesia
//
//  Created by Selase Kwawu on 01/05/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit
import AVFoundation


class RecordingViewController: UITableViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL: URL?
    var sounds : [Sound] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playButton.isEnabled = false
        saveButton.isEnabled  = false
        
        
    }
    
    func setupRecorder() {
        
        
        do {
            //Create URL
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Create URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL  = NSURL.fileURL(withPathComponents: pathComponents)!
            
            
            
            //Create settings for ahe audio recorder
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.00 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            
            //Create Audio Recorder OBJECT
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
        } catch let error as NSError{
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if (audioRecorder?.isRecording)! {
            //Stop the recording
            audioRecorder?.stop()
            
            //Change button title to record
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            saveButton.isEnabled  = true
        } else {
            //Start Recording
            audioRecorder?.record()
            
            //change button title to stop
            recordButton.setTitle("Stop", for: .normal)
            
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {
            print(error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            sounds = try context.fetch(Sound.fetchRequest())
            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
        catch {
            
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath)
        
        let sound = sounds[indexPath.row]
        
        
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        
        do {
            
            GSAudio.sharedInstance.playSound(soundFileName: "\(sound)")
            
            //try audioPlayer = AVAudioPlayer(data: sound.audio! as Data)
            //audioPlayer?.play()
        } catch {
            print(error)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
  
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let sound = sounds[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                sounds = try context.fetch(Sound.fetchRequest())
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch {
                
            }

        } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
     }
 
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
