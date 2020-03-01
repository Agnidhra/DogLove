//
//  DogApi.swift
//  DogLove
//
//  Created by Agnidhra Gangopadhyay on 2/27/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

class DogApi {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        var url : URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        print("breed + \(breed)")
        let randomImageEndpoint = DogApi.Endpoint.randomImageForBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, responsse, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task  = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let imageFromApi = UIImage(data: data)
            completionHandler(imageFromApi, nil)
        })
        task.resume()
    }

    class func requestAllBreeds(completionHandler: @escaping ([String]?, Error?) -> Void){
       let listAllBreeds = DogApi.Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: listAllBreeds) { (data, responsse, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let dogBreeds = try! decoder.decode(AllBreeds.self, from: data)
            completionHandler(dogBreeds.message.keys.map({$0}), nil)
        }
        task.resume()
    }

}
