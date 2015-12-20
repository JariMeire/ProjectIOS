import UIKit

class InstellingenViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var amountOfDaysPicker: UIPickerView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var location: String?
    var amountOfDays = 0
    var amountOfDaysArray = [1, 2, 3, 4, 5, 6, 7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        checkValidLocationName()
        
        amountOfDaysPicker.delegate = self
        amountOfDaysPicker.dataSource = self
        amountOfDaysPicker.selectRow(amountOfDays - 1, inComponent: 0, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "OverviewBackground")!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let input = locationTextField.text ?? ""
            location = input.stringByReplacingOccurrencesOfString(" ", withString: "")
            defaults.setObject(location, forKey: "location")
            defaults.setInteger(amountOfDays, forKey: "amountOfDays")
        }
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
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let amount = amountOfDaysArray[row]
        let text: String
        if amount == 1 {
            text =  String(amount) + " dag"
        } else {
            text = String(amount) + " dagen"
        }
        return NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
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
    
    @IBAction func unwindToInstellingen(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? DaysViewController{
            amountOfDays = sourceViewController.amountOfDays
        }
    }
}