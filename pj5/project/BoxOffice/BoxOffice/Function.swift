//
//  Function.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/04.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

/*
 open - 전부허용
 public - 상속 X
 ------ 프레임워크
 internal - 다른프레임워크 접근불가, 현재 프레임워크에선 전부 접근가능
 private -
 fileprivate - 현재파일에서만 접근
 */

//protocol SendDataDeleagate {
//    func sendData(data: [Movies])
//}


class MovieService {
    
//    let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidReceiveMovies")
    
    private var datTask: URLSessionDataTask?

    private func sendRequest(_ url: URL, completion: @escaping ([Movies]) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session: URLSession = URLSession(configuration: .default)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(apiResponse.movies)
                
                //NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": apiResponse.movies] )
            } catch(let err) {
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    internal func requestMovies(urlInt: Int?, completion: @escaping ([Movies]) -> Void) {
        
        var components = URLComponents(string: "https://connect-boxoffice.run.goorm.io/movies")
        
        guard let urlInt = urlInt else {
            if let url: URL = components?.url {
                self.sendRequest(url) { movies in
                    completion(movies)
                }
            }
            return
        }
        
        let orderType = URLQueryItem(name: "order_type", value: "\(urlInt)")
        components?.queryItems = [orderType]
        
        guard let url: URL = components?.url else {
            return
        }
        self.sendRequest(url) { movies in
            completion(movies)

        }
    }

}



//func makeURLAlertAction (urlstring: Int) {
//    
//    var components = URLComponents(string: "https://connect-boxoffice.run.goorm.io/movies")
//    let orderType = URLQueryItem(name: "order_type", value: "\(urlstring)")
//    components?.queryItems = [orderType]
//    guard let url: URL = components?.url else {
//        return
//    }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    let session: URLSession = URLSession(configuration: .default)
//    
//    let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//        
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        
//        guard let data = data else { return }
//        
//        do {
//            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
//            self.arryMovies = apiResponse.movies
//            
//            DispatchQueue.main.async {
//                self.tableView?.reloadData()
//            }
//            
//        } catch(let err) {
//            print(err.localizedDescription)
//        }
//    }
//    
//    dataTask.resume()
//}
