import UIKit

class DaysViewController: UITableViewController {
    
    var location: String = ""
    var amountOfDays: Int = 7
    var counter: Int = 0
    var days: [Day] = []
    var currentTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        counter = 0
        tableView!.delegate = self
        
        currentTask = Service.sharedService.createFetchTask(location, amountOfDays: amountOfDays) {
            [unowned self] result in switch result {
            case .Success(let days):
                self.days = days
                self.title = days[0].location
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
    
    func setDayName(name: String, counter: Int) -> String {
        switch counter {
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
        cell.nameLabel.text = setDayName(day.name, counter: counter)
        cell.temperatureLabel.text = String(day.temperature) + "°C"
        cell.descriptionLabel.text = day.description
        counter += 1
        return cell
    }
    
    @IBAction func unwindToLocationLabel(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? InstellingenViewController{
            location = sourceViewController.location!
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
            let instellingenViewController =  navigation.topViewController as! InstellingenViewController
            instellingenViewController.amountOfDays = amountOfDays
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
