//
//  ViewController.swift
//  WeatherReport
//
//  Created by Dan Hoang on 9/19/14.
//  Copyright (c) 2014 Dan Hoang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityField: UITextField!
    @IBOutlet var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityField.delegate = self
        self.weatherLabel.numberOfLines = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func findWeatherPressed(sender: AnyObject) {
        var currentCity = self.cityField.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        var urlString = "http://www.weather-forecast.com/locations/\(currentCity)/forecasts/latest"
        println(urlString)
        var url = NSURL(string: urlString)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)
            if urlContent.containsString("<span class=\"phrase\">") {
                //            println(urlContent)
                var contentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                //</span>
                var followContentArray = contentArray[1].componentsSeparatedByString("</span>")
                //            println(contentArray[1])
                var weatherReport = followContentArray[0] as String
                var weatherReportShown = weatherReport.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                self.weatherLabel.text = weatherReportShown
                println(self.weatherLabel.text)
                println(weatherReportShown)
            }
            else {
                self.weatherLabel.text = "Couldn't find city with name \(currentCity)"
                println("Couldn't find city with name \(currentCity)")
            }
            //º
        }
        task.resume()
        
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.cityField.resignFirstResponder()
        return true
    }
}

