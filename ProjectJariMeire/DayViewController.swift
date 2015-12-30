import UIKit

class DayViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
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
            pressureLabel.text = "Luchtdruk " + String(day.pressure) + " hpa"
            humidityLabel.text = "Luchtvochtigheid " + String(day.humidity) + " %"
            windLabel.text = "Wind " + String(day.wind) + " km/h"
        }
        setBackground()
    }
    
    //bij schermrotatie setbackground opnieuw uitvoeren met andere afmetingen
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        setBackground()
    }
    
    //bijpassende achtergrondafbeelding mooi weergeven adhv schermgrootte
    func setBackground() -> Void {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: day!.main)?.drawInRect(self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
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