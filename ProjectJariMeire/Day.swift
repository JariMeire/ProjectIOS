import Foundation

class Day{
    let location: String
    let name: String
    let temperature: Int
    let main: String
    let description: String
    let icon: String
    
    init(location: String, name: String, temperature: Int, main: String, description: String, icon: String){
        self.location = location
        self.name = name
        self.temperature = temperature
        self.main = main
        self.description = description
        self.icon = icon
    }
}
var teller: Int = 0
extension Day{
    convenience init(json: NSDictionary, city: String) throws {
        guard let dt = json["dt"] as? NSTimeInterval else{
            throw Service.Error.MissingJsonProperty(name: "dt")
        }
        guard let weather = json["weather"] as? NSArray else{
            throw Service.Error.MissingJsonProperty(name: "weather")
        }
        guard let temp = json["temp"] as? NSDictionary else{
            throw Service.Error.MissingJsonProperty(name: "temp")
        }
        guard let min = temp["min"] as? Double else {
            throw Service.Error.MissingJsonProperty(name: "min")
        }
        guard let max = temp["max"] as? Double else {
            throw Service.Error.MissingJsonProperty(name: "max")
        }
        guard let weatherdata = weather[0] as? NSDictionary else {
            throw Service.Error.MissingJsonProperty(name: "weather array")
        }
        guard let description = weatherdata["description"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "description")
        }
        guard let main = weatherdata["main"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "main")
        }
        guard let icon = weatherdata["icon"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "icon")
        }
        
        
        //Hier kan je nu zogezegd met de gegevens doen wat je maar wilt
        
        func setWeekdayName(weekday: Int) -> String {
            switch weekday {
            case 1:
                return "Zondag"
            case 2:
                return "Maandag"
            case 3:
                return "Dinsdag"
            case 4:
                return "Woensdag"
            case 5:
                return "Donderdag"
            case 6:
                return "Vrijdag"
            case 7:
                return "Zaterdag"
            default:
                return "Dag " + String(weekday)
            }
        }
        
        func setDescription(description: String) -> String {
            switch description {
            case "light rain":
                return "lichte regen";
            case "moderate rain":
                return "af en toe buien";
            case "heavy intensity rain":
                return "zware regenval";
            case "sky is clear":
                return "heldere hemel";
            case "broken clouds":
                return "bewolkt";
            case "overcast clouds":
                return "zwaar bewolkt";
            case "few clouds":
                return "afwisselend bewolkt";
            case "scattered clouds":
                return "af en toe bewolkt";
            default:
                return description;
            }
        }
        
        func setDayName(dt: NSTimeInterval) -> String {
            let date = NSDate(timeIntervalSince1970: dt)
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let components = calendar!.components(.Weekday, fromDate: date)
            let weekday = components.weekday
            return setWeekdayName(weekday)
        }
        
        func setTemperature(min: Double, max: Double) -> Int {
            let total = min + max
            let average: Int = Int(total / 2)
            return average
        }
        
        let dayName = setDayName(dt)
        let temperature = setTemperature(min, max: max)
        let weatherDescription = setDescription(description)
        
        self.init(location: city, name: dayName, temperature: temperature, main: main, description: weatherDescription, icon: icon)
        //teller += 1
    }
}

