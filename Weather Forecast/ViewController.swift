//
//  ViewController.swift
//  Weather Forecast
//
//  Created by Ashwini Purohit on 02/02/17.
//  Copyright © 2017 Ashwini Purohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var city: UITextField!
    let borderAlpha : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0
    @IBAction func submit(_ sender: Any) {
        var message = ""
        let url = URL(string: "http://www.weather-forecast.com/locations/"+self.city.text!.replacingOccurrences(of: " ", with: "-")+"/forecasts/latest")!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if error != nil{
                print(error!)
                
            }else{
                if let unwrappedData = data{
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    if let contentArray = dataString?.components(separatedBy: stringSeparator){
                        if contentArray.count>1{
                            stringSeparator="</span>"
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count>0{
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(message)
                            }
                            
                        }
                    }
                    
                }
                
                
            }
            if(message==""){
                message="Sorry! No data found. Please try again!"
            }
            DispatchQueue.main.sync(execute: {
                self.result.text=message
            })
        }
        task.resume()

    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.city.delegate=self
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
