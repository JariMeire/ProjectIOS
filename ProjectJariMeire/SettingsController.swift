import UIKit
import MapKit

class SettingsController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var amountOfDaysPicker: UIPickerView!
    @IBOutlet weak var temperatureSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var locationsPicker: UIPickerView!
    let defaults = NSUserDefaults.standardUserDefaults()
    var celsius = true
    var city: String?
    var location: Location!
    var amountOfDays = 0
    var amountOfDaysArray = [1, 2, 3, 4, 5, 6, 7]
    var locationsArray = [""]
    var lastUsed = false
    var switchPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        //savebutton disablen zolang user niks wijzigt
        checkValidLocationName()
        amountOfDaysPicker.delegate = self
        amountOfDaysPicker.dataSource = self
        if defaults.boolForKey(Constants.celsius) == false {
            temperatureSwitch.on = defaults.boolForKey(Constants.celsius)
        }
        if defaults.objectForKey(Constants.lastUsedLocations) != nil {
            locationsArray = (defaults.objectForKey(Constants.lastUsedLocations)) as! [String]
        }
        selectRowOfPickerViews()
        setMapView()
    }
    
    //de locatie op kaart weergeven
    func setMapView() -> Void {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let visibleRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.region = visibleRegion
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
    
    //overgang, controle of opslaan werd aangeklikt
    //ingevulde of aangepaste waarden opslaan
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if lastUsed == false {
                if locationTextField.text != "" {
                    city = locationTextField.text!
                }
            }
            if !locationsArray.contains(city!) && city != "" {
                appendToLocationArray()
            }
            defaults.setObject(city, forKey: Constants.city)
            if(switchPressed == true){
                defaults.setBool(celsius, forKey: Constants.celsius)
            }
            defaults.setInteger(amountOfDays, forKey: Constants.amountOfDays)
        }
    }
    
    //de 5 laatst gebruikte locaties worden opgeslagen
    func appendToLocationArray() -> Void {
        if locationsArray.count <= 4 {
            locationsArray.insert(city!, atIndex: 0)
        } else {
            locationsArray.removeLast()
            locationsArray.insert(city!, atIndex: 0)
        }
        defaults.setObject(locationsArray, forKey: Constants.lastUsedLocations)
    }
    
    //celsius of fahrenheit
    @IBAction func switchPressed(sender: AnyObject) {
        if temperatureSwitch.on {
            celsius = true
        } else {
            celsius = false
        }
        saveButton.enabled = true
        switchPressed = true
    }
    
    //annuleer
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //user moet op enter klikken
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
        lastUsed = false
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidLocationName()
    }
    
    
    //PICKERVIEWs
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 2){
            let amount = amountOfDaysArray[row]
            if amount == 1 {
                return String(amount) + " dag"
            }
            return String(amount) + " dagen"
        } else {
            return locationsArray[row]
        }
    }
    
    //pickerview met tag 1 zijn laatst gebruikte locaties
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return locationsArray.count
        } else {
            return amountOfDaysArray.count
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //pickerviews opvullen/ tag 2 = amountofdayspickerview
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 2) {
            amountOfDays = row + 1
            saveButton.enabled = true
        } else {
            city = locationsArray[row]
            lastUsed = true
            saveButton.enabled = true
        }
    }
    
    //juiste rij selecteren van de pickerviews
    func selectRowOfPickerViews() -> Void {
        amountOfDaysPicker.selectRow(amountOfDays - 1, inComponent: 0, animated: true)
        if city == nil {
            locationsPicker.selectRow(1, inComponent: 0, animated: true)
        } else {
            locationsPicker.selectRow(locationsArray.indexOf(city!)!, inComponent: 0, animated: true)
        }
    }
}