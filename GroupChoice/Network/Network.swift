//
//  Network.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 8/8/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import Foundation


struct Network {
    
    func fetchGenericData<T: Codable>(url: String, completion: @escaping (T) -> () ) {
        let url = URL(string: url)
        
        //let accessToken = "dpg0Fzxn401atueQqn3xQXnSGfx-7G9QyFrB79VYxp341NVO66XLB8-ziOXyqndjrW8gV6zcnqlT3oaJ38n8kP2pb5C8MKqVvaOZnMYJaYdj93g_r74v5b41dJKXXYx"
       // var request = URLRequest(url: url!)
        //request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization" )
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonError {
                print ("Failed to decode json: ", jsonError)
            }
            }.resume()
    }
}
