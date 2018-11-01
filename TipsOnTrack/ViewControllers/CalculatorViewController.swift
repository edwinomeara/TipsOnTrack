

import UIKit
import GoogleMobileAds

class CalculatorViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var calculatorScrollView: UIScrollView!
    @IBOutlet weak var adBannerView: GADBannerView!
    @IBOutlet weak var ButtonsView: UIView!
    @IBOutlet weak var CalculatorView: UIView!
    @IBOutlet weak var CalculateButton: UIButton!
    @IBOutlet weak var TipsEarned: UITextField! // move up 250
    @IBOutlet weak var VehicleCostPerMile: UITextField! //move up 100
    @IBOutlet weak var NumberOfDeliveries: UITextField! // move up 250
    @IBOutlet weak var MileagePayPerMile: UITextField!
    @IBOutlet weak var MileagePayMilesDriven: UITextField!
    @IBOutlet weak var HourlyPayOnRoad: UITextField!
    @IBOutlet weak var HourlyPayInStore: UITextField!
    @IBOutlet weak var HoursWorkedOnRoad: UITextField!
    @IBOutlet weak var HoursWorkedInStore: UITextField!
    @IBOutlet weak var AvgTipPerRunLabel: UILabel!
    @IBOutlet weak var HourlyPayLabel: UILabel!
    @IBOutlet weak var TotalEarnedLabel: UILabel!
    
    //let time = [[Int](1...23),[Int](00...59)] Could do it this way which looks much cleaner in code while the String version looks messier in code but better in the application
    
    let time = [[String](arrayLiteral: " 0 Hours"," 1 Hour", " 2 Hours" , " 3 Hours", " 4 Hours", " 5 Hours" , " 6 Hours", " 7 Hours", " 8 Hours" , " 9 Hours","10 Hours", "11 Hours" , "12 Hours","13 Hours", "14 Hours" , "15 Hours" , "16 Hour", "17 Hours" , "18 Hours", "19 Hours", "20 Hours" , "21 Hours", "22 Hours", "23 Hours"),[String](arrayLiteral: " 0 Minutes"," 1 Minute", " 2 Minutes", " 3 Minutes", " 4 Minutes", " 5 Minutes", " 6 Minutes", " 7 Minutes", " 8 Minutes", " 9 Minutes", "10 Minutes","11 Minutes", "12 Minutes", "13 Minutes", "14 Minutes", "15 Minutes","16 Minutes", "17 Minutes", "18 Minutes", "19 Minutes", "20 Minutes","21 Minutes", "22 Minutes", "23 Minutes", "24 Minutes", "25 Minutes","26 Minutes", "27 Minutes", "28 Minutes", "29 Minutes", "30 Minutes","31 Minutes", "32 Minutes", "33 Minutes", "34 Minutes", "35 Minutes","36 Minutes", "37 Minutes", "38 Minutes", "39 Minutes", "40 Minutes","41 Minutes", "42 Minutes", "43 Minutes", "44 Minutes", "45 Minutes","46 Minutes", "47 Minutes", "48 Minutes", "49 Minutes", "50 Minutes","51 Minutes", "52 Minutes", "53 Minutes", "54 Minutes", "55 Minutes","56 Minutes", "57 Minutes", "58 Minutes", "59 Minutes")]
    
    var pickerForOnRoad = UIPickerView()
    var pickerForInStore = UIPickerView()
    
    override func viewDidLoad() {
        CalculatorView.layer.cornerRadius = 10
        CalculateButton.layer.cornerRadius = 10
        CalculateButton.layer.borderWidth = 2
        CalculateButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toolBarCreator()
        AvgTipPerRunLabel.text = "Average Tip Per Run : $0.00"
        HourlyPayLabel.text = "Hourly Pay : $0.00"
        TotalEarnedLabel.text = "Total : $0.00"
        adBannerView.adUnitID = "ca-app-pub-3741367181958953/2537080962"
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
    }
    
    @IBAction func CalculateButton(_ sender: Any) {
        
        guard let hoursWorkedInStoreDouble = HelpfulFunctions().timeToDouble(input: HoursWorkedInStore.text!)
            else {
                print(1)
                errorFound()
                return
        }
        
        guard let hoursWorkedOnRoadDouble = HelpfulFunctions().timeToDouble(input: HoursWorkedOnRoad.text!)
            else{
                print(2)
                errorFound()
                return
        }
        
        guard let hourlyPayInStoreDouble = HelpfulFunctions().stringToDouble(input: HourlyPayInStore.text!)
            else{
                print(3)
                errorFound()
                return
        }
        
        guard let hourlyPayOnRoadDouble = HelpfulFunctions().stringToDouble(input: HourlyPayOnRoad.text!)
            else{
                print(4)
                errorFound()
                return
        }
        
        guard let milesDriven = HelpfulFunctions().stringToDouble(input: MileagePayMilesDriven.text!) else{
            errorFound()
            return
        }
        
        guard let milesePay = HelpfulFunctions().stringToDouble(input: MileagePayPerMile.text!) else{
            errorFound()
            return
        }
        
        guard let tipsEarnedDouble = HelpfulFunctions().stringToDouble(input: TipsEarned.text!) else{
            errorFound()
            return
        }
        
        let vehicleCostDouble = HelpfulFunctions().stringToDouble(input: VehicleCostPerMile.text!)
        
        guard let numberOfDeliveriesDouble = HelpfulFunctions().stringToDouble(input: NumberOfDeliveries.text!)
            else{
                errorFound()
                return
        }
        
        //Turn text fields back to black
        AvgTipPerRunLabel.textColor = .white
        HourlyPayLabel.textColor = .white
        TotalEarnedLabel.textColor = .white
        
        //left align
        AvgTipPerRunLabel.textAlignment = .left
        HourlyPayLabel.textAlignment = .left
        TotalEarnedLabel.textAlignment = .left
        
        //Total pay earned using function found in Calculations class
        TotalEarnedLabel.text = "Total Earned : $" + String(format: "%.2f", (Calculations().findTotal(using: hoursWorkedInStoreDouble, hoursWorkedOnRoadDouble, hourlyPayInStoreDouble, hourlyPayOnRoadDouble, milesDriven, milesePay, tipsEarnedDouble, and: vehicleCostDouble ?? 0)))
        
        let total = Calculations().findTotal(using: hoursWorkedInStoreDouble, hoursWorkedOnRoadDouble, hourlyPayInStoreDouble, hourlyPayOnRoadDouble, milesDriven, milesePay, tipsEarnedDouble, and: vehicleCostDouble ?? 0)
        
        //Average tip calculation using function found in Calculation class
        AvgTipPerRunLabel.text = "Average Tip : $" + String(format: "%.2f", (Calculations().averageTipPerRun(using: tipsEarnedDouble, and: numberOfDeliveriesDouble)))
        
        //Average Hourly Pay using function found in calculation class
        HourlyPayLabel.text = "Hourly Earnings : $" + String(format: "%.2f", (Calculations().hourlyPayAverage(using: total, hoursWorkedInStoreDouble, and: hoursWorkedOnRoadDouble)))
    }
    
    func errorFound() {
        
        //Center message
        AvgTipPerRunLabel.textAlignment = .center
        HourlyPayLabel.textAlignment = .center
        TotalEarnedLabel.textAlignment = .center
        
        //Turn text fields red for given warning
        AvgTipPerRunLabel.textColor = .yellow
        HourlyPayLabel.textColor = .yellow
        TotalEarnedLabel.textColor = .yellow
        
        //Warnings given to user
        AvgTipPerRunLabel.text = "Invalid Number Found"
        HourlyPayLabel.text = "Or Input Is Empty"
        TotalEarnedLabel.text = "Fix Error To Continue"
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return time.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return time[component].count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hrs = time[0][pickerView.selectedRow(inComponent: 0)]
        let min = time[1][pickerView.selectedRow(inComponent: 1)]
        let hrsShortened = hrs.prefix(2)
        let minShortened = min.prefix(2)
        
        if pickerView == pickerForOnRoad {
            HoursWorkedOnRoad.text = hrsShortened + "hrs " + minShortened + "min"
        }
        else{
            HoursWorkedInStore.text = hrsShortened + "hrs " + minShortened + "min"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(time[component][row])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //creates a toolbar for every keyboard
    func toolBarCreator(){
        onRoadPicker(HoursWorkedOnRoad)
        inStorePicker(HoursWorkedInStore)
        createToolBar(TipsEarned)
        createToolBar(VehicleCostPerMile)
        createToolBar(NumberOfDeliveries)
        createToolBar(MileagePayPerMile)
        createToolBar(MileagePayMilesDriven)
        createToolBar(HourlyPayOnRoad)
        createToolBar(HourlyPayInStore)
    }
    
    func onRoadPicker(_ textField : UITextField){
        // UIPickerView
        pickerForOnRoad.delegate = self
        pickerForOnRoad.dataSource = self
        HoursWorkedOnRoad.inputView = pickerForOnRoad
        
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
    
    func inStorePicker(_ textField : UITextField){
        // UIPickerView
        pickerForInStore.delegate = self
        pickerForInStore.dataSource = self
        HoursWorkedInStore.inputView = pickerForInStore
        
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
    
    @objc func doneClick() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
}

extension CalculatorViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == NumberOfDeliveries || textField == TipsEarned) {
            calculatorScrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
        if (textField == VehicleCostPerMile) {
            calculatorScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        calculatorScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
