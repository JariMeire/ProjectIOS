import UIKit
import MapKit

class SettingsController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var amountOfDaysPicker: UIPickerView!
    @IBOutlet weak var temperatureSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var celsius = true
    var city: String?
    var amountOfDays = 0
    var amountOfDaysArray = [1, 2, 3, 4, 5, 6, 7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        checkValidLocationName()
        
        amountOfDaysPicker.delegate = self
        amountOfDaysPicker.dataSource = self
        amountOfDaysPicker.selectRow(amountOfDays - 1, inComponent: 0, animated: true)
        if defaults.boolForKey("celsius") == false {
            temperatureSwitch.on = defaults.boolForKey("celsius")
        }
        setMapView()
    }
    
    func setMapView() -> Void {
        let center = CLLocationCoordinate2D(latitude: defaults.doubleForKey("latitude"), longitude: defaults.doubleForKey("longitude"))
        let visibleRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.region = visibleRegion
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let input = locationTextField.text ?? ""
            city = input.stringByReplacingOccurrencesOfString(" ", withString: "")
            defaults.setObject(city, forKey: "city")
            defaults.setInteger(amountOfDays, forKey: "amountOfDays")
            defaults.setBool(celsius, forKey: "celsius")
        }
    }
    
    @IBAction func switchPressed(sender: AnyObject) {
        if temperatureSwitch.on {
            celsius = true
        } else {
            celsius = false
        }
        saveButton.enabled = true
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //gebruiker kan niet saven als hij nog aan het typen is
        saveButton.enabled = false
    }
    
    func checkValidLocationName() {
        let text = locationTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidLocationName()
    }
    
    
    //PICKERVIEW: aantal dagen
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let amount = amountOfDaysArray[row]
        if amount == 1 {
           return String(amount) + " dag"
        }
        return String(amount) + " dagen"
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountOfDaysArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        //hoeveel secties? We hebben maar 1 component
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        amountOfDays = row + 1
        saveButton.enabled = true
    }
}