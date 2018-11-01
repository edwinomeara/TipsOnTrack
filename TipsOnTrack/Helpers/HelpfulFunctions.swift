
import Foundation
import UIKit

class HelpfulFunctions{
    
    //convert time into a number
    func timeToDouble(input: String) -> Double? {
        print(input)
        
        var timeConvert = input //" 12 hrs 5 min"
        timeConvert = timeConvert.replacingOccurrences(of: "hrs", with: "")//" 12 5 min"
        timeConvert = timeConvert.replacingOccurrences(of: "min", with: "")//" 12 5"
        timeConvert = timeConvert.trimmingCharacters(in: .whitespaces)//"12 5"
        
        //seperated input to be able to check if only one number for hour or minute was entered
        //and if so to add a 0 to the front
        var hr = timeConvert.components(separatedBy: " ").first //"12"
        var min = timeConvert.components(separatedBy: " ").last //"5"
        
        if(hr?.count != 2){ //12
            hr = "0" + hr!
        }
        if(min?.count != 2){ //05
            min = "0" + min!
        }
        
        let answer = hr! + min! //1205
        return Double(answer)
    }
    
    //convert String (eg. "5.00") into double (5.00)
    func stringToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func createToolBar(_ textField : UITextField){
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        //done moved over to right side of toolbar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CalculatorViewController.doneClick))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
}
