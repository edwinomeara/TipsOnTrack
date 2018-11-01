
import UIKit
import CoreData
import GoogleMobileAds

//allows user to view and edit their inputs
class ListViewController: UIViewController {
    
    @IBOutlet weak var adBannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    var dataList = [UserData]()
    var sortedDataList = [UserData]()
    var userDataArray = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        do {
            let dataList = try PersistenceService.context.fetch(fetchRequest)
            self.dataList =  dataList.reversed() // reversed so the newest input is at the top
            self.tableView.reloadData()
        } catch {}
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        adBannerView.adUnitID = "ca-app-pub-3741367181958953/2537080962"
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
    }
    
    @IBAction func editRows(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBAction func trash(_ sender: Any) {
        let alert = UIAlertController(title: "Delete All?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            do {
                try PersistenceService.context.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "UserData")))
                PersistenceService.saveContext()
            } catch{}
        }))
        tableView.reloadData()
        self.present(alert, animated: true, completion: nil)
    }
    
    func save(date: String, hours: Double, income: Double, miles: Double) {
        let userData = UserData(context: PersistenceService.context)
        userData.hours = hours
        userData.income = income
        userData.miles = miles
        userData.date = date
        PersistenceService.saveContext()
        self.dataList.append(userData)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)//test different styles!
            
            cell.textLabel?.text = "\(dataList[indexPath.row].date)"
            cell.detailTextLabel?.text = "Income: $\(dataList[indexPath.row].income),  Hourly:  \(Calculations().hourlyPayAverageForHome(income: dataList[indexPath.row].income, hours: (dataList[indexPath.row].hours)/100)),  \nTime: \(hoursOutput(hours: dataList[indexPath.row].hours)),  Miles: \(String(dataList[indexPath.row].miles))"
            cell.detailTextLabel?.numberOfLines = 0
            return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let userData = dataList[indexPath.row]
            PersistenceService.context.delete(userData)
            PersistenceService.saveContext()
            dataList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func hoursOutput(hours: Double) -> String {
        let hour = Int(hours/100)
        let min = Int((((hours/100) - Double(hour)) * 100).rounded())
        //for min had to use rounded() or else it would come up with a lower value
        return "\(hour) Hours and \(min) Minutes"
    }
}
