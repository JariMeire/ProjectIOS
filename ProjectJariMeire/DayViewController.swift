import UIKit

class DayViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var day: Day?
    var position: Int?
    
    @IBAction func overzicht(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let day = day {
            navigationItem.title = setDayName(day.name, counter: position!)
            temperatureLabel.text = String(day.temperature) + "°C"
            descriptionLabel.text = day.description
        }
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: day!.main)!)
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
}