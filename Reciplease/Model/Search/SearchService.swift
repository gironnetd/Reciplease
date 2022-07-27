//
//  SearchService.swift
//  Reciplease
//
//  Created by damien on 21/07/2022.
//

import Foundation
import Alamofire
import CoreData

class SearchService {
    
    static var shared: SearchService = SearchService()
    
    private init(){}
    
    private lazy var type = Parameter(key: "type", value: "public")
    private lazy var q = Parameter(key: "q")
    
    private lazy var appID: Parameter = {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let apiKeys = NSDictionary(contentsOfFile:filePath!)
        let value = apiKeys?.object(forKey: "app_id") as! String
        return Parameter(key: "app_id", value: value, description: "")
    }()
    
    private lazy var appKey: Parameter = {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let apiKeys = NSDictionary(contentsOfFile:filePath!)
        let value = apiKeys?.object(forKey: "app_key") as! String
        return Parameter(key: "app_key", value: value, description: "")
    }()
    
    private var parameters: [String: String] {
        return [type, q, appID, appKey].reduce(into: [:], { result, parameter in
            result[parameter.key] = parameter.value
        })
    }
    
    func retrieveRecipes(ingredients: [String], callBack: @escaping ([Recipe]?, AFError?) -> Void) {
        q.value = ingredients.joined(separator: ", ")
        AF.request("https://api.edamam.com/api/recipes/v2", method: .get, parameters: parameters)
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let response):
                    callBack(response.hits.map { hit in hit.recipe }, nil)
                    break
                case .failure(let error):
                    callBack(nil, error)
                    break
                }
            }
    }
}
