//
//  ViewController.swift
//  Lyrics Fetcher
//
//  Created by Matthew Riley on 10/23/18.
//  Copyright © 2018 Matthew Riley. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var lyricsTextView: UITextView!
    
    //The base URL for the lyrics API, aka the point where we connect it
    let lyricsAPIBaseURL = "https://api.lyrics.ovh/v1/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {

        guard let artistName = artistTextField.text, let songTitle = songTextField.text else {
            return
        }
        
        //Since we can't use spaces in our URL, we need to replace spaces in the song and artist name with +
        let artistNameURLComponent = artistName.replacingOccurrences(of: " ", with: "+")
        let songTitleURLComponent = songTitle.replacingOccurrences(of: " ", with: "+")

        
        
        //Full URL for the request we will make to the API
        let requestURL = lyricsAPIBaseURL + artistNameURLComponent + "/" + songTitleURLComponent
        
        //We are going to use Alamofire to create an actual request using that URL
        let request = Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        
        //Now we need to acually make our request
        request.responseJSON { response in
            //We switch based on the response result, which can be either success or failure
            switch response.result {
            case .success(let value):
                //In the case of success, the request has succeeded, and we've gotten some data back
                print(value)
                
                let json = JSON(value)
                
                print(json)
                
                self.lyricsTextView.text = json["lyrics"].stringValue
                
                print("Success!")
            case .failure(let error):
                //In the case of failure, the request has failed and we've gotten an error back
                print("Error!")
                print(error.localizedDescription)
            }
        }
    }
}
