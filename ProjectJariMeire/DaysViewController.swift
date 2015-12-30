import UIKit

class DaysViewController: UITableViewController {
    
    var city: String = ""
    var amountOfDays: Int = 7
    var days: [Day] = []
    var currentTask: NSURLSessionTask?
    var location: Location?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        //controle of er instellingen van de user lokaal zijn opgeslaan
        if defaults.stringForKey(Constants.city) != nil {
            city = defaults.stringForKey(Constants.city)!
        }
        if defaults.integerForKey(Constants.amountOfDays) != 0 {
            amountOfDays = defaults.integerForKey(Constants.amountOfDays)
        }
        tableView!.delegate = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "OverviewBackground"))
        //weerdata ophalen
        currentTask = Service.sharedService.createFetchTask(city, amountOfDays: amountOfDays) {
            [unowned self] result in switch result {
            case .Success(let days):
                self.days = days
                self.title = days[0].city
                self.location = days[0].location
                self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
        currentTask!.resume()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    //tableview opvullen
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "DayTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DayTableViewCell
        let day = days[indexPath.row]
        cell.nameLabel.text = setDayName(day.name, dayNumber: indexPath.row)
        setTemperatureLabel(day.temperature, cell: cell)
        cell.icon.image = UIImage(named: day.icon)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func setDayName(name: String, dayNumber: Int) -> String {
        switch dayNumber {
        case 0:
            return "Vandaag"
        case 1:
            return "Morgen"
        default:
            return name
        }
    }
    
    //celsius of fahrenheit instellen adhv instelling user
    func setTemperatureLabel(temperature: Int, cell: DayTableViewCell) -> Void {
        if defaults.boolForKey(Constants.celsius) == true {
            cell.temperatureLabel.text = String(temperature) + "°C"
        } else {
            let fahrenheit = Int((Double(temperature) * 1.8) + 32)
            cell.temperatureLabel.text = String(fahrenheit) + "°F"
        }
    }
    
    //waarden nodig om de weerdata op te halen die de user heeft ingesteld bij de instellingen
    @IBAction func unwindToLocationLabel(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? SettingsController {
            city = sourceViewController.city!
            amountOfDays = sourceViewController.amountOfDays
            viewDidLoad()
        }
    }
    
    //overgaan naar een ander scherm
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //controle of men overgaat naar het detailscherm of niet
        if segue.identifier == "ShowDetail" {
            let dayViewController = segue.destinationViewController as! DayViewController
            if let selectedDayCell = sender as? DayTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedDayCell)!
                let selectedDay = days[indexPath.row]
                dayViewController.day = selectedDay
                dayViewController.position = indexPath.row
            }
        } else {
            let navigation = segue.destinationViewController as! UINavigationController
            let settingsViewController =  navigation.topViewController as! SettingsController
            settingsViewController.amountOfDays = amountOfDays
            settingsViewController.city = city
            settingsViewController.location = location
        }
    }
}
