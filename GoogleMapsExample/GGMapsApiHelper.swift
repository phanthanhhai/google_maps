import Foundation

typealias LocationModel = (coordinate: CLLocationCoordinate2D, placeName: String)
typealias RequestSuccess = (LocationModel) -> Void
typealias RequestFail = (NSError?) -> Void
let LocationDefault: LocationModel = (CLLocationCoordinate2DMake(21.0173236, 105.7837568), "Framgia")


class GGMapsApiHelper {
    
    private var requestManager : AFHTTPRequestOperationManager!
    private var url : String!
    private var successHandle : RequestSuccess!
    private var failHandle : RequestFail!
    private var keyword: String! = ""
    
    init(keyword: String) {
        self.requestManager = AFHTTPRequestOperationManager()
        self.requestManager.requestSerializer.timeoutInterval = 10 * 3
        self.keyword = keyword
        self.url = getUrl()
    }

    
    /*Call to start network request */
    func startSearchPlace(
        success: RequestSuccess,
        failure: RequestFail) -> Void
    {
        if self.successHandle == nil {
            self.successHandle = success
        }
        
        if self.failHandle == nil {
            self.failHandle = failure
        }
        
        requestManager.POST(self.url, parameters: [], success: { (operation : AFHTTPRequestOperation!,response : AnyObject!) -> Void in
            print(response)
            var mapModel = LocationDefault
            if response != nil {
                let json = JSON(response!)
                if let results = json["results"].array {
                    if results.count > 0 {
                        if let onePlace = results[0]["geometry"]["location"].dictionaryObject {
                            let lat = onePlace.doubleOrZero("lat")
                            let long = onePlace.doubleOrZero("lng")
                            mapModel.coordinate = CLLocationCoordinate2DMake(lat, long)
                        }
                        if let namePlace = results[0]["formatted_address"].string {
                            mapModel.placeName = namePlace
                        }
                    }
                }
            }
            self.successHandle(mapModel)
        }, failure: { (operation : AFHTTPRequestOperation?, error: NSError!) -> Void in
            self.failHandle(error)
        })
    }
    
    func getUrl()->(String) {
        let urlEncode_ = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyC9WPFitmzQrjeZfcT3dpGsWJmxbLJj6ew&query=" + keyword
        if let urlEncodeValue = urlEncode_.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return urlEncodeValue
        }
        return ""
    }
}