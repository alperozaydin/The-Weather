//
//  ViewController.swift
//  The Weather
//
//  Created by Alper on 7/11/16.
//  Copyright © 2016 Alper. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {

    //@IBOutlet weak var enteredCity: UITextField!
    
    @IBOutlet weak var enteredCity: UITextField!
    @IBOutlet weak var cityResult: UILabel!
    
    
    
    @IBAction func submittedCity(_ sender: AnyObject?) {
        
        if enteredCity.text == "" {
            
            showError()
        
        }
            
        else {
        
        
            let url = URL(string: "http://www.weather-forecast.com/locations/" + enteredCity.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest")
            
            
            if (url != nil){
                
                
                let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    var urlError = false
                    
                    var weather = ""
                    
                    if error == nil {
                        
                        let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as NSString!
                        
                        let convertedUrlContent = urlContent as! String
                        
                        if convertedUrlContent.range(of: "You may have mistyped the address") != nil {
                            
                           urlError = true
                            
                            
                        }
                        
                        else {
                        
                            var urlContentArray = urlContent?.components(separatedBy: "<span class=\"phrase\">")
                            
                            if (urlContentArray?.count)! > 0{
                                
                                var weatherArray = urlContentArray?[1].components(separatedBy: "</span>")
                                
                                weather = (weatherArray?[0])! as String
                                
                                weather = weather.replacingOccurrences(of: "&deg;", with: "º")
                                
                                
                            }
                            else {
                                
                                urlError = true
                            }
                        }
                        
                    }
                        
                    else {
                        
                        urlError = true
                        
                    }
                    
                    DispatchQueue.main.async{
                        
                        if urlError == true {
                            
                            self.showError()
                            
                        }
                            
                        else{
                            
                            self.cityResult.text = weather
                            
                            
                        }
                        
                    }
                    
                    
                })
                
                task.resume()
                
                
                
            }
            else{
                
                showError()
                
            }
        }
        
    }
    
    
    func showError() {
        
        cityResult.text = "We couldn't get the weather information for " + enteredCity.text! + ". Please try again."
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        submittedCity(nil)
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.enteredCity.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

