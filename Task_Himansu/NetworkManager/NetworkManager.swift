//
//  WebAPIClient.swift
//  Task_Himansu
//
//  Created by Himansu Panigrahi on 5/30/24.
//
import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    func getRequest<T:Decodable>(
        endpoint: Endpoints,
        page: Int,
        limit: Int,
        resultType:T.Type,
        completionHandler: @escaping ([T]?, Int, String?) -> Void) {
        
            if Reachability.isConnectedToNetwork{
                guard let url = URL(string: endpoint.url) else {
                    completionHandler(
                        nil, 
                        page,
                        Constants.INVALID_URL
                    )
                    return
                }
                
                URLSession.shared.dataTask(with: url) {
                    (responseData, httpURLResponse, error) in
                    
                    if let error = error {
                        completionHandler(
                            nil,
                            page,
                            error.localizedDescription
                        )
                        
                    }
                    else{
                        if let responseData = responseData{
                            let decoder = JSONDecoder()
                            do {
                                let result = try decoder.decode([T].self, from: responseData)
                                
                                completionHandler(
                                    result,
                                    page,
                                    nil
                                )
                            }
                            catch let error{
                                debugPrint("error occured while decoding = \(error.localizedDescription)")
                                completionHandler(
                                    nil,
                                    page,
                                    error.localizedDescription
                                )
                            }
                        }
                        else{
                            completionHandler(
                                nil,
                                page,
                                Constants.SOMETHING_WENT_WRONG
                            )
                        }
                    }
                }.resume()
            }
            else{
                completionHandler(
                    nil,
                    page,
                    Constants.NO_INTERNET
                )
            }
    }
}

struct Reachability{
    
    //NOTE : This is not a true reachibility class. It has been added just to show internet failure case handling
    static var isConnectedToNetwork:Bool{
        return true
    }
}

