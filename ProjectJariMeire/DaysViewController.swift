import UIKit

class DaysViewController: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var celsius: Bool = true
    var city: String = ""
    var amountOfDays: Int = 7
    var days: [Day] = []
    var currentTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        if defaults.stringForKey("city") != nil {
            city = defaults.stringForKey("city")!
        }
        if defaults.integerForKey("amountOfDays") != 0 {
            amountOfDays = defaults.integerForKey("amountOfDays")
        }
        tableView!.delegate = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "OverviewBackground"))
        currentTask = Service.sharedService.createFetchTask(city, amountOfDays: amountOfDays) {
            [unowned self] result in switch result {
            case .Success(let days):
                self.days = days
                self.title = days[0].city
                self.defaults.setDouble(days[0].location.latitude, forKey: "latitude")
                self.defaults.setDouble(days[0].location.longitude, forKey: "longitude")
                self.tableView.reloadData()
                /*self.errorView.hidden = true*/
            case .Failure(let error):
                print(error)
                /*self.errorLabel.text = "\(error)"
                self.errorView.hidden = false*/
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
    
    func setTemperatureLabel(temperature: Int, cell: DayTableViewCell) -> Void {
        if defaults.boolForKey("celsius") == true {
            cell.temperatureLabel.text = String(temperature) + "°C"
        } else {
            let fahrenheit = Int((Double(temperature) * 1.8) + 32)
            cell.temperatureLabel.text = String(fahrenheit) + "°F"
        }
    }
    
    @IBAction func unwindToLocationLabel(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? SettingsController {
            city = sourceViewController.city!
            amountOfDays = sourceViewController.amountOfDays
            viewDidLoad()
        }
    }
    
    //overgaan naar detailview wanneer er op bijhorende tablecell geklikt wordt
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        }
    }
    
    /*func loadTestData(){
    let name1 = "Vandaag"
    let temperatuur1 = "10°C"
    let description1 = "licht bewolkt"
    
    let name2 = "Morgen"
    let temperatuur2 = "8°C"
    let description2 = "af en toe buien"
    
    let day1 = Day(name: name1, temperature: temperatuur1, description: description1)
    let day2 = Day(name: name2, temperature: temperatuur2, description: description2)
    
    days += [day1, day2]
    
    }*/
}
