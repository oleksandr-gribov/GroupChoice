//
//  Network.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/8/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import Foundation
import UIKit

struct Network {
    
    static func fetchGenericData<T: Codable>(url: URL, completion: @escaping (T) -> Void ) {
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonError {
                print("Failed to decode json: ", jsonError)
            }
            }.resume()
    }
}
