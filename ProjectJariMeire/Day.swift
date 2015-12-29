import Foundation

class Day{
    let city: String
    let name: String
    let temperature: Int
    let main: String
    let description: String
    let icon: String
    let location: Location
    let pressure: Int
    let humidity: Int
    let wind: Int
    
    init(city: String, name: String, temperature: Int, main: String, description: String, icon: String, location: Location, pressure: Int, humidity: Int, wind: Int){
        self.city = city
        self.name = name
        self.temperature = temperature
        self.main = main
        self.description = description
        self.icon = icon
        self.location = location
        self.pressure = pressure
        self.humidity = humidity
        self.wind = wind
    }
}
var teller: Int = 0
extension Day{
    convenience init(json: NSDictionary, city: String, coord: NSDictionary) throws {
        guard let dt = json["dt"] as? NSTimeInterval else{
            throw Service.Error.MissingJsonProperty(name: "dt")
        }
        guard let weather = json["weather"] as? NSArray else{
            throw Service.Error.MissingJsonProperty(name: "weather")
        }
        guard let pressure = json["pressure"] as? Double else{
            throw Service.Error.MissingJsonProperty(name: "pressure")
        }
        guard let humidity = json["humidity"] as? Int else{
            throw Service.Error.MissingJsonProperty(name: "humidity")
        }
        guard let speed = json["speed"] as? Double else{
            throw Service.Error.MissingJsonProperty(name: "speed")
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
        guard var icon = weatherdata["icon"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "icon")
        }
        guard var lon = coord["lon"] as? Double else {
            throw Service.Error.MissingJsonProperty(name: "lon")
        }
        guard var lat = coord["lat"] as? Double else {
            throw Service.Error.MissingJsonProperty(name: "lat")
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
                return "Lichte regen";
            case "moderate rain":
                return "Af en toe buien";
            case "heavy intensity rain":
                return "Zware regenval";
            case "sky is clear":
                return "Heldere hemel";
            case "broken clouds":
                return "Bewolkt";
            case "overcast clouds":
                return "Zwaar bewolkt";
            case "few clouds":
                return "Afwisselend bewolkt";
            case "scattered clouds":
                return "Af en toe bewolkt";
            case "light snow":
                return "Lichte sneeuwval";
            case "sneeuw":
                return "Sneeuwbuien";
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
        let iconGeneral = String(icon.characters.dropLast())
        let location = Location(latitude: lat, longitude: lon)
        
        self.init(city: city, name: dayName, temperature: temperature, main: main, description: weatherDescription, icon: iconGeneral, location: location, pressure: Int(pressure), humidity: humidity, wind: Int(speed * 3.6))
        //teller += 1
    }
}

