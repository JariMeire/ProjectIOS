import Foundation

class Service
{
    enum Error: ErrorType
    {
        case InvalidJsonData(message: String?)
        case MissingJsonProperty(name: String)
        case MissingResponseData
        case NetworkError(message: String?)
        case UnexpectedStatusCode(code: Int)
    }
    
    static let sharedService = Service()
    
    private let session: NSURLSession
    
    private init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createFetchTask(locatie: String, completionHandler: Result<[Day]> -> Void) -> NSURLSessionTask {
        let q = (locatie == "") ? "Gent" : locatie
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=" + q + "&mode=json&units=metric&cnt=7&APPID=1915045e7d99dc089dce5278018d0a13")!
        return session.dataTaskWithURL(url) {
            data, response, error in
            let completionHandler: Result<[Day]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(.Failure(.NetworkError(message: error?.description)))
                return
            }
            guard response.statusCode == 200 else {
                completionHandler(.Failure(.UnexpectedStatusCode(code: response.statusCode)))
                return
            }
            guard let data = data else {
                completionHandler(.Failure(.MissingResponseData))
                return
            }
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary else {
                    completionHandler(.Failure(.InvalidJsonData(message: "Data does not contain a root object.")))
                    return
                }
                guard let city = json["city"] as? NSDictionary else {
                    completionHandler(.Failure(.MissingJsonProperty(name: "city")))
                    return
                }
                guard let name = city["name"] as? String else {
                    completionHandler(.Failure(.MissingJsonProperty(name: "name")))
                    return
                }
                guard let jsonDays = json["list"] as? [NSDictionary] else {
                    completionHandler(.Failure(.MissingJsonProperty(name: "list")))
                    return
                }
                let days = try jsonDays.map { try Day(json : $0, city: name) }
                completionHandler(.Success(days))
            } catch let error as NSError {
                completionHandler(.Failure(.InvalidJsonData(message: error.description)))
            } catch let error as Error {
                completionHandler(.Failure(error))
            }
        }
    }
}