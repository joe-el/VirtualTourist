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
    // MARK: Authentication Properties
    
    struct Auth {
        static let secretKey = "10e28ca450a42099"
        static let apiKey = "ed30536af534be32ae6bee3f180ee67f"
    }
    
    // MARK: Udacity API URL's
    
    enum EndPoints {
        // flickr API restURL endpoint
        static let testEcho = "https://www.flickr.com/services/rest/?method=flickr.test.echo&name=value&api_key=\(Auth.apiKey)&format=json"
        static let base = "https://api.flickr.com/services/rest/"
        
        // flickr API arguments
        static let method = "?method=flickr.photos.search"
        static let apiKey = "&api_key=\(Auth.apiKey)"
        static let format = "&format=json"
        static let jsonCallBack = "&nojsoncallback=1"
        static let safeSearch = "&safe_search=2"
        static let hasGeo = "&has_geo=1"
        static let radius = "&radius=1"
        static let extras = "&extras=url_m"
        static let perPage = "&per_page=25"
        
        case testEchoService
        case photosSearch(Double, Double, Int)
        
        var stringValue: String {
            switch self {
            case .testEchoService:
                return EndPoints.testEcho
            case .photosSearch(let lat, let long, let pageNumber):
                return EndPoints.base + EndPoints.method + EndPoints.apiKey + EndPoints.format + EndPoints.jsonCallBack + EndPoints.safeSearch + EndPoints.hasGeo + "&lat=\(lat)&long=\(long)" + EndPoints.radius + EndPoints.extras + EndPoints.perPage + "&page=\(pageNumber)"
            }
        }
        
        var url: URL {
            // we'll force unwrap it for now
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Helper Methods for API Requests
    
    // GETting HTTP Request
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
    
    // request the flickr.test.echo service
    class func requestFlickrTestEcho(completionHandler: @escaping (TestResponse?, Error?) -> Void) {
        taskForGETRequest(url: EndPoints.testEchoService.url, responseType: TestResponse.self) { (response, error) in
            if let response = response {
                print(response)
                completionHandler(response, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    // helper methods to get Flickr Images
    class func requestFlickrData(lat: Double, long: Double, pageNum: Int, completionHandler: @escaping (FlickrPhotos?, Error?) -> Void) {
        taskForGETRequest(url: EndPoints.photosSearch(lat, long, pageNum).url, responseType: FlickrPhotos.self) { (response, error) in
            if let response = response {
                completionHandler(response, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
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
    
    private class func isPhotoInCache(for pin: Pin, with id: String) -> Data? {
        if let pinPhotos = pin.photos?.allObjects as? [Photo], let photoData = pinPhotos.first(where: { $0.id == id })?.photoData {
            return photoData
        }
        
        return nil
    }
    
    class func requestSinglePhoto(url: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                completionHandler(data, error)
            }
            task.resume()
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
}
