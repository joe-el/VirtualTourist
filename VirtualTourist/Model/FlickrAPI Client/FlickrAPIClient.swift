//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/1/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import UIKit

class FlickrAPIClient {
    
    // MARK: - Authentication Properties:
    
    struct Auth {
        static let secretKey = "46bf11fe18df255c"
        static let apiKey = "a97f8f34adf1b3ae5bdb30687dca1cd8"
    }
    
    // MARK: - Udacity API URL's:
    
    enum EndPoints {
        // Flickr API restURL endpoint—
        static let testEcho = "https://www.flickr.com/services/rest/?method=flickr.test.echo&name=value"
        static let base = "https://api.flickr.com/services/rest/"
        
        // Flickr API arguments—
        static let method = "?method=flickr.photos.search"
        static let apiKey = "&api_key=\(Auth.apiKey)"
        static let format = "&format=json"
        static let jsonCallBack = "&nojsoncallback=1"
        static let safeSearch = "&safe_search=2"
        static let hasGeo = "&has_geo=1"
        static let extras = "&extras=url_m"
        
        case testEchoService
        case photosSearch(Double, Double, Int)
        
        var stringValue: String {
            switch self {
            case .testEchoService:
                return EndPoints.testEcho
            case .photosSearch(let lat, let long, let pageNumber):
                return EndPoints.base + EndPoints.method + EndPoints.apiKey + EndPoints.format + EndPoints.jsonCallBack + EndPoints.safeSearch + EndPoints.hasGeo + "&lat=\(lat)&long=\(long)" + EndPoints.extras + "&per_page=10&page=\(pageNumber)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)! // We'll force unwrap it for now:
        }
    }
    
    // MARK: - Helper Methods for API Requests:
    
    // GETting HTTP Request—
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
           
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    // A helper method to get Flickr Images—
    class func requestFlickrData(lat: Double, long: Double, pageNum: Int, completionHandler: @escaping (FlickrPhotos?, Error?) -> Void) {
//        let pageNum = getRandomPageNumber(totalPicsAvailable: totalPageAmount, maxNumPicsdisplayed: picsPerPage)
        
        taskForGETRequest(url: EndPoints.photosSearch(lat, long, pageNum).url, responseType: FlickrPhotos.self) { (response, error) in
            if let response = response {
                completionHandler(response, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
//    private func getRandomPageNumber(totalPicsAvailable: Int, maxNumPicsdisplayed: Int) -> Int {
//        let flickrLimit = 4000
//        // Available total number of pics or flickr limit
//        let numberPages = min(totalPicsAvailable, flickrLimit) / maxNumPicsdisplayed
//        let randomPageNum = Int.random(in: 0...numberPages)
//        print("totalPicsAvaible is \(totalPicsAvailable), numPage is \(numberPages)",
//             "randomPageNum is \(randomPageNum)")
//        
//        return randomPageNum
//    }
    
    class func grabPhoto(pin: Pin, urlPath: String, completion: @escaping (Data?, Error?) -> Void) {
        if let image = isPhotoInCache(for: pin, with: urlPath) {
            DispatchQueue.main.async {
                completion(image, nil)
            }
        } else {
            requestSinglePhoto(url: urlPath) { data, error in
                if error != nil {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else {
                    if let data = data {
                        DispatchQueue.main.async {
                            savePhotoInCache(for: pin, with: urlPath, photoData: data)
                            completion(data, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, nil)
                        }
                    }
                }
            }
        }
    }
    
    private class func savePhotoInCache(for pin: Pin, with id: String, photoData: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newPhoto = Photo(context: context)
        newPhoto.id = id
        newPhoto.photoData = photoData
        newPhoto.pin = pin
        pin.addToPhotos(newPhoto)
        try? context.save()
    }
    
    private class func isPhotoInCache(for pin: Pin, with id: String) -> Data? {
        if let pinPhotos = pin.photos?.allObjects as? [Photo], let photoData = pinPhotos.first(where: { $0.id == id })?.photoData {
            return photoData
        }
        
        return nil
    }

    // Marked as a class method, weil we don't need an instance of the FlickrAPI in order to use it—
    class func requestSinglePhoto(url: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                completionHandler(data, error)
            }
            task.resume()
        }
    }
    
}
