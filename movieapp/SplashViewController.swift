//
//  SplashViewController.swift
//  movieapp
//
//  Created by Mac on 07/11/22.
//

import UIKit

class SplashViewController: UIViewController {

//    let appdata = AppData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMenuData()
    }
    
    func getMenuData() {
        
        guard let url = URL(string: "https://jwxebkwcfj.execute-api.us-east-1.amazonaws.com/dev/menu") else {return}
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
        //headers
        var headers : [String : String] = [:]
            headers["Authorization"] = "cf606825b8a045c1aae39f7fe39de7d7"
            headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
       
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data{
                let menuModel = try? JSONDecoder().decode(menumodel.self , from: data)
                AppData.shared.MenuData = menuModel?.body?.data ?? []
                
                
                if let homeId = AppData.shared.MenuData[0].id{
                    self.getHomeData(homeid: String(homeId))
                }

                
                print("menuModel count", menuModel?.body?.data?.count)
            }
        }.resume()
  
    }
   
    func getHomeData(homeid: String) {
        
        guard let url = URL(string: "https://n6lih99291.execute-api.ap-south-1.amazonaws.com/dev/home") else {return}
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
        //headers
        var headers : [String : String] = [:]
            headers["Authorization"] = "cf606825b8a045c1aae39f7fe39de7d7"
            headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        
        let body : [String : Any] = ["homeid": homeid]
        if let bodydata = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted){
            urlRequest.httpBody = bodydata
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let homemodel = try? JSONDecoder().decode(HomeModel.self, from: data){
                    AppData.shared.homeData = homemodel.response?.data?.playlists ?? []
//                    self.appdata.titletext = homemodel.response?.data?.title ?? ""
                    AppData.shared.allHomeData[homeid] = homemodel.response?.data
                   
                    AppData.shared.MenuData[0].isselected = true
                    
                    DispatchQueue.main.async {
                        self.navigateToHome()
                    }
            }
        }
        
                
        }.resume()
                
    }

    func navigateToHome() {
        let controller = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: "RootViewController")
        navigationController?.viewControllers = [controller]
        navigationController?.popToRootViewController(animated: true)
    }
}
