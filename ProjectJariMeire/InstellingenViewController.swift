import UIKit

class InstellingenViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var location: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        checkValidLocationName()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            location = locationTextField.text ?? ""
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
    
}