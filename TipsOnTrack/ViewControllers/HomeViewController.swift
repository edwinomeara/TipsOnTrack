//ca-app-pub-3741367181958953~1527251626
import UIKit
import CoreData
import Charts
import GoogleMobileAds
import StoreKit

class HomeViewController: UIViewController, UIScrollViewDelegate,  UIPickerViewDataSource, UIPickerViewDelegate {
    
    let currentDate = Date()
    let calendar = Calendar.current
    var yearArray = [Int](2017...2028)
    @IBOutlet weak var adBannerView: GADBannerView!
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var firstPopUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var sadFaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var mostRecentView: UIView!
    @IBOutlet weak var recentDateLabel: UILabel!
    @IBOutlet weak var recentTotalEarnedLabel: UILabel!
    @IBOutlet weak var recentHourlyPayLabel: UILabel!
    @IBOutlet weak var recentTimeWorkedLabel: UILabel!
    @IBOutlet weak var recentMilesDrivenLabel: UILabel!
    @IBOutlet weak var yearChosen: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popupCancelButton: UIButton!
    @IBOutlet weak var popupAddButton: UIButton!
    @IBOutlet weak var totalEarnedLabel: UILabel!
    @IBOutlet weak var hoursWorkedLabel: UILabel!
    @IBOutlet weak var milesDrivenLabel: UILabel!
    @IBOutlet weak var hourlyAverageLabel: UILabel!
    @IBOutlet weak var avgDailyTotalIncomeLabel: UILabel!
    @IBOutlet weak var avgMilesPerShiftLabel: UILabel!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var totalIncome: UITextField!
    @IBOutlet weak var timeWorked: UITextField!
    @IBOutlet weak var milesDriven: UITextField!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var centerPopupConstraint: NSLayoutConstraint!
    @IBOutlet weak var weeklyStatsView: UIView!
    @IBOutlet weak var weeklyTotalEarnedLabel: UILabel!
    @IBOutlet weak var weeklyHourlyAverageLabel: UILabel!
    @IBOutlet weak var weeklyTimeWorkedLabel: UILabel!
    @IBOutlet weak var weeklyMilesDrivenLabel: UILabel!
    
    var dataList = [UserData]()
    
    //let time = [[Int](1...23),[Int](00...59)] String version looks messier in code but better in application
    let time = [[String](arrayLiteral: " 0 Hours"," 1 Hour", " 2 Hours" , " 3 Hours", " 4 Hours", " 5 Hours" , " 6 Hours", " 7 Hours", " 8 Hours" , " 9 Hours","10 Hours", "11 Hours" , "12 Hours","13 Hours", "14 Hours" , "15 Hours" , "16 Hour", "17 Hours" , "18 Hours", "19 Hours", "20 Hours" , "21 Hours", "22 Hours", "23 Hours"),[String](arrayLiteral: " 0 Minutes"," 1 Minute", " 2 Minutes", " 3 Minutes", " 4 Minutes", " 5 Minutes", " 6 Minutes", " 7 Minutes", " 8 Minutes", " 9 Minutes", "10 Minutes","11 Minutes", "12 Minutes", "13 Minutes", "14 Minutes", "15 Minutes","16 Minutes", "17 Minutes", "18 Minutes", "19 Minutes", "20 Minutes","21 Minutes", "22 Minutes", "23 Minutes", "24 Minutes", "25 Minutes","26 Minutes", "27 Minutes", "28 Minutes", "29 Minutes", "30 Minutes","31 Minutes", "32 Minutes", "33 Minutes", "34 Minutes", "35 Minutes","36 Minutes", "37 Minutes", "38 Minutes", "39 Minutes", "40 Minutes","41 Minutes", "42 Minutes", "43 Minutes", "44 Minutes", "45 Minutes","46 Minutes", "47 Minutes", "48 Minutes", "49 Minutes", "50 Minutes","51 Minutes", "52 Minutes", "53 Minutes", "54 Minutes", "55 Minutes","56 Minutes", "57 Minutes", "58 Minutes", "59 Minutes")]
    
    let datePicker = UIDatePicker()
    var yearPicker = UIPickerView()
    var timeWorkedPicker = UIPickerView()
    
     var counter = [Counter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = retreiveDataList()
        adBannerView.adUnitID = "ca-app-pub-3741367181958953/2537080962"
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
        
        setupViews()
        createDatePicker()
        createYearPicker(yearChosen)
        createTimeWorkedPicker(timeWorked)
        HelpfulFunctions().createToolBar(totalIncome)
        HelpfulFunctions().createToolBar(milesDriven)
        calculate()
        findDataForPastWeek()
        findDataForMostRecent()
        
        yearChosen.text = String(calendar.component(.year, from: currentDate))
        //set to 2018 so user knows what year they are viewing in chart
        findValuesForYear(year: String(calendar.component(.year, from: currentDate)))
        //sets the chart values to the current year
        
        //core data fetch
        let fetchRequestForCount: NSFetchRequest<Counter> = Counter.fetchRequest()
        do{
            let count = try PersistenceService.context.fetch(fetchRequestForCount)
            counter = count
        } catch {}
        
          incrementCounter()
    }
    
    //function to make sure the appstore rating doesn't constantly pop up
    func incrementCounter(){
        let countedNumber = Counter(context: PersistenceService.context)
        if counter.count == 0 {
            counter.append(countedNumber)
            counter[0].count = 1
            countedNumber.count = counter[0].count
        } else {
            counter[0].count += 1
            countedNumber.count = counter[0].count
        }
        PersistenceService.saveContext()
        if counter[0].count == 3 || counter[0].count == 10 || counter[0].count % 30 == 0 {
            requestReview()
        }
    }
    //requests app store rating
    func requestReview(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            return
        }
    }
    //input popup directions
    @IBAction func showPopup(_ sender: Any) {
        centerPopupConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
        })
    }
    //close input popup directions
    @IBAction func closePopup(_ sender: Any) {
        centerPopupConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
            self.donePressed()
        })
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let saveDate = date.text
            else {
                return
        }
        
        guard let saveTimeWorked = HelpfulFunctions().timeToDouble(input: timeWorked.text!)
            else {
                return
        }
        
        guard let saveIncome = HelpfulFunctions().stringToDouble(input: totalIncome.text!)
            else{
                return
        }
        guard let saveMiles = HelpfulFunctions().stringToDouble(input: milesDriven.text!)
            else{
                return
        }
        ListViewController().save(date: saveDate,hours: saveTimeWorked, income: saveIncome, miles: saveMiles)
        dataList = retreiveDataList()
        findMonthlyValues(data: dataList)
        calculate()
        findDataForMostRecent()
        findDataForPastWeek()
        closePopup(self)
        donePressed()
    }
    
    //custom date picker for allowing user to insert the desired date
    func createDatePicker() {//date picker not picker view need to create its own toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClick))
        toolbar.setItems([flexibleSpace,done], animated: true)
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.maximumDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = calendar.date(byAdding: .year, value: -1, to: currentDate)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        if pickerView.tag == 1 {
            return time.count
        } else {
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView.tag == 1 {
            return time[component].count
        } else {
            return yearArray.count
        }
    }
    
    //split pickerview into two seperate scroll wheels one for hours and one for minutes.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let hrs = time[0][pickerView.selectedRow(inComponent: 0)]
            let min = time[1][pickerView.selectedRow(inComponent: 1)]
            let hrsShortened = hrs.prefix(2)
            let minShortened = min.prefix(2)
            timeWorked.text = hrsShortened + " hrs " + minShortened + " min"
        } else{
            yearChosen.text = String(yearArray[row])
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            
            return String(time[component][row])
        } else {
            return String(yearArray[row])
        }
    }
    
    func createYearPicker(_ textField : UITextField){
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearChosen.inputView = yearPicker
        textField.inputAccessoryView = createToolBar()
    }
    
    func createTimeWorkedPicker(_ textField : UITextField){
        timeWorkedPicker.tag = 1
        timeWorkedPicker.delegate = self
        timeWorkedPicker.dataSource = self
        timeWorked.inputView = timeWorkedPicker
        textField.inputAccessoryView = createToolBar()
    }
    
    //finds the most recent data the user has entered
    func findDataForMostRecent() {
        if dataList.count > 0 {
            let lastDay = dataList.last
            recentDateLabel.text = lastDay?.date
            recentTotalEarnedLabel.text = ("$\(String(format: "%.2f",lastDay!.income))")
            recentTimeWorkedLabel.text = hoursOutput(hours: lastDay!.hours)
            recentMilesDrivenLabel.text = ("\(String(format: "%.2f",lastDay!.miles)) Miles")
            recentHourlyPayLabel.text = ("$ \(String(format: "%.2f",Calculations().hourlyPayAverageForHome(income: lastDay!.income, hours: (lastDay!.hours)/100)))/Hr")
        }
        else {
            recentDateLabel.text = ""
            recentTimeWorkedLabel.text = "0 Hours 0 Min"
            recentMilesDrivenLabel.text = "0 Miles"
            recentHourlyPayLabel.text = "$0/Hr"
            recentTotalEarnedLabel.text = "$0.00"
        }
    }
    //finds data from the past week that users entered
    func findDataForPastWeek() {
        var date = calendar.startOfDay(for: Date())
        var pastWeek = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        for _ in 1 ... 6 {
            date = calendar.date(byAdding: .day, value: -1, to: date)!
            pastWeek.append(dateFormatter.string(from: date))
        }
        pastWeek.append(dateFormatter.string(from: currentDate))
        //for loop wouldn't add the current date, but this works fine
        findDaysWorked(days: pastWeek)
    }
    
    func findDaysWorked(days: [String]) {
        var count = 0
        var userDays = [String]()
        while count != dataList.count {
            userDays.append(dataList[count].date)
            count += 1
        }
        let commonElements = Array(Set(days).intersection(Set(userDays)))
        calculateWorkdayValues(days: commonElements)
    }
    
    func calculateWorkdayValues(days: [String]){
        var count = 0
        var totalEarned = 0.0
        var hours = 0.0
        var miles = 0.0
        
        while count != dataList.count{
            if days.contains(dataList[count].date){
                totalEarned += dataList[count].income
                hours += dataList[count].hours/100
                miles += dataList[count].miles
            }
            count += 1
        }
        if count != 0 {
            weeklyTotalEarnedLabel.text = ("$ \(String(format: "%.2f", Calculations().roundToPlaces(value: totalEarned, places: 2)))")
            weeklyHourlyAverageLabel.text = ("$ \(String(format: "%.2f",Calculations().hourlyPayAverageForHome(income: totalEarned, hours: hours)))/Hr")
            weeklyTimeWorkedLabel.text = Calculations().findTime(hours: hours)
            weeklyMilesDrivenLabel.text = ("\(String(format: "%.2f", Calculations().roundToPlaces(value: miles, places: 2))) Miles")
        }
    }
    
    //calculates the necessary inputs with help from the Calculations.swift in the Helpers file
    func calculate(){
        var count = 0
        var totalIncome = 0.0
        var totalMileage = 0.0
        var totalHours = 0.0
        
        while count != dataList.count {
            totalIncome += dataList[count].income
            totalMileage += dataList[count].miles
            totalHours += dataList[count].hours/100
            count += 1
        }
        if(count != 0){
            avgDailyTotalIncomeLabel.text = ("$ \(String(format: "%.2f",Calculations().roundToPlaces(value: totalIncome / Double(count), places: 2)))")
            avgMilesPerShiftLabel.text = ("\(String(format: "%.2f",Calculations().roundToPlaces(value: totalMileage / Double(count), places: 2))) Miles")
            hoursWorkedLabel.text = Calculations().findTime(hours: totalHours)
            milesDrivenLabel.text = ("\(String(format: "%.2f", Calculations().roundToPlaces(value: totalMileage, places: 2))) Miles")
            totalEarnedLabel.text = ("$ \(String(format: "%.2f", Calculations().roundToPlaces(value: totalIncome, places: 2)))")
            hourlyAverageLabel.text = ("$ \(String(format: "%.2f",Calculations().hourlyPayAverageForHome(income: totalIncome, hours: totalHours)))/Hr")
        } else {
            avgDailyTotalIncomeLabel.text = "$0.00"
            avgMilesPerShiftLabel.text = "0 Miles"
            hoursWorkedLabel.text = "0 Days 0 Hours 0 Minutes"
            hourlyAverageLabel.text = "$0.00/Hr"
            totalEarnedLabel.text = "$0.00"
            milesDrivenLabel.text = "0 Miles"
        }
    }
    
    //creates an array of the values from the year the user has chosen
    func findValuesForYear(year: String) {
        var counter = 0
        var yearData:[UserData] = []
        while counter != dataList.count {
            if(year == String(dataList[counter].date.suffix(4))){
                yearData.append(dataList[counter])
            }
            counter += 1
        }
        findMonthlyValues(data: yearData)
    }
    
    //finds the monthly value for given year
    func findMonthlyValues(data: [UserData]){
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var janIncome = 0.0, febIncome = 0.0, marIncome = 0.0, aprIncome = 0.0, mayIncome = 0.0, junIncome = 0.0, julIncome = 0.0, augIncome = 0.0, sepIncome = 0.0, octIncome = 0.0, novIncome = 0.0, decIncome = 0.0
        var thisYear = [Double]()
        var count = 0
        while count != data.count {
            let month = data[count].date.prefix(3)
            switch month{
            case "Jan":
                janIncome += data[count].income
            case "Feb":
                febIncome += data[count].income
            case "Mar":
                marIncome += data[count].income
            case "Apr":
                aprIncome += data[count].income
            case "May":
                mayIncome += data[count].income
            case "Jun":
                junIncome += data[count].income
            case "Jul":
                julIncome += data[count].income
            case "Aug":
                augIncome += data[count].income
            case "Sep":
                sepIncome += data[count].income
            case "Oct":
                octIncome += data[count].income
            case "Nov":
                novIncome += data[count].income
            case "Dec":
                decIncome += data[count].income
            default: print("?") // shouldn't be possible to hit the default case
            }
            count += 1
        }
        
        thisYear = [janIncome, febIncome, marIncome, aprIncome, mayIncome, junIncome, julIncome, augIncome, sepIncome, octIncome, novIncome, decIncome]
        setChart(dataPoints: months, values: thisYear)
    }
    
    //using iOS charts this functions will set it to the proper inputs
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.configureDefaults()
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .white
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.valueFormatter = BarChartFormatter()
        
        var checkIfEmpty = 0.0
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            checkIfEmpty += values[i]
            dataEntries.append(dataEntry)
        }
        firstPopUpConstraint.constant = 600
        sadFaceConstraint.constant = 600
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartDataSet.valueTextColor = .white
        chartDataSet.colors = [.init(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]
        
        if checkIfEmpty == 0.0 && yearChosen.text != String(calendar.component(.year, from: currentDate)){
            showSadFace()
            chartDataSet.colors = [.clear]
            chartDataSet.valueTextColor = .clear
        }
        if checkIfEmpty == 0.0 && yearChosen.text == String(calendar.component(.year, from: currentDate)){
            showFirstPopUp()
            chartDataSet.colors = [.clear]
            chartDataSet.valueTextColor = .clear
        }
        barChartView.data = chartData
    }
    
    //if it's the users first time using a popup will appear with a message
    func showFirstPopUp(){
        firstPopUpConstraint.constant = -20
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //if the user requests to visit a year with no inputs a popup will appear with a warning
    func showSadFace(){
        sadFaceConstraint.constant = -20
        //centerPopupConstraint.constant = 0
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func retreiveDataList() -> [UserData]{
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        do {
            let dataList = try PersistenceService.context.fetch(fetchRequest)
            self.dataList = dataList
        } catch {} // add error handling here!
        return dataList
    }
    
    @objc func doneClick() { // for date picker! different from -- donePressed()
        let formattedDate = DateFormatter()
        formattedDate.dateStyle = .medium
        formattedDate.timeStyle = .none
        let actualDate = formattedDate.string(from: datePicker.date)
        date.text = "\(actualDate)"
        view.endEditing(true)
    }
    
    //used to create and customize each toolbar
    func createToolBar() -> UIToolbar{
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        //done moved over to right side of toolbar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HomeViewController.donePressed))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    //exits view when done is pressed, also is used to reset chart based on year chosen
    @objc func donePressed() {
        findValuesForYear(year: yearChosen.text!)
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func hoursOutput(hours: Double) -> String {
        let hour = Int(hours/100)
        let min = Int((((hours/100) - Double(hour)) * 100).rounded())
        //for min had to use rounded() or else it would come up with a lower value
        return "\(hour) Hours \(min) Minutes"
    }
    
    //sets up the view with the desired colors, corner radius and border adjustments.
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        weeklyStatsView.layer.cornerRadius = 8
        statsView.layer.cornerRadius = 8
        barChartView.layer.borderWidth = 1
        barChartView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        popupView.layer.cornerRadius = 10
        popupAddButton.layer.cornerRadius = 5
        popupAddButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        popupAddButton.layer.borderWidth = 2
        popupCancelButton.layer.cornerRadius = 5
        popupCancelButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        popupCancelButton.layer.borderWidth = 2
        mostRecentView.layer.cornerRadius = 8
    }
}

//customize the bar chart 
private extension BarLineChartViewBase {
    func configureDefaults() {
        chartDescription?.enabled = false
        legend.enabled = false
        xAxis.setLabelCount(12, force: false)
        xAxis.labelPosition = .bottom
        backgroundColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        isUserInteractionEnabled = false
        animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        for axis in [xAxis, leftAxis] { //removes all the background x/y axis lines
            axis.drawAxisLineEnabled = false
            axis.drawGridLinesEnabled = false
        }
        xAxis.labelTextColor = .white
        leftAxis.labelTextColor = .white
        rightAxis.enabled = false
    }
}




