//
//  RootViewController.swift
//  movieapp
//
//  Created by Mac on 27/10/22.
//

import UIKit

class RootViewController: UIViewController, SettingTableViewCellDelegate {
    func LoginTapped() {
        menuTapped()
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func RegisterTapped() {
        menuTapped()
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RegisterViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func SettingsTapped() {
        print("setting Tapped")
    }
    

    @IBOutlet weak var homeview : UIView!
    @IBOutlet weak var homeviewwidth : NSLayoutConstraint!
    @IBOutlet weak var menuview : UIView!
    @IBOutlet weak var menuleading : NSLayoutConstraint!
    @IBOutlet weak var menuTableview : UITableView!
    @IBOutlet weak var menuwidth : NSLayoutConstraint!
    @IBOutlet weak var homeTableview : UITableView!
    @IBOutlet weak var homeTitle : UILabel!
    
    var isMenuOpen: Bool = false
    var MenuData: [Menu] = []
    var homeData: [Playlist] = []
    var titletext: String = ""
    
    var allHomeData : [String: HomeData] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableview.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        menuTableview.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        menuTableview.delegate = self
        menuTableview.dataSource = self
        homeviewwidth.constant = UIScreen.main.bounds.width
        
        homeTableview.register(UINib(nibName: "CarousalTableViewCell", bundle: nil), forCellReuseIdentifier: "CarousalTableViewCell")
        homeTableview.delegate = self
        homeTableview.dataSource = self
        
        menuwidth.constant = menuViewWidth
        menuleading.constant = -menuViewWidth

        getMenuData()
        
    }
    

     @IBAction func menuTapped () {
        if isMenuOpen {
            menuleading.constant = -menuViewWidth
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { bool in
                self.isMenuOpen = false
        }
        }
        else {
            menuleading.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { bool in
                self.isMenuOpen = true
            }
            }
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
                self.MenuData = menuModel?.body?.data ?? []
                
                if let homeId = self.MenuData[0].id{
                    self.getHomeData(homeid: String(homeId))
                }
                DispatchQueue.main.async {
                    self.menuTableview.reloadData()
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
                    self.homeData = homemodel.response?.data?.playlists ?? []
                    self.titletext = homemodel.response?.data?.title ?? ""
                    self.allHomeData[homeid] = homemodel.response?.data
                   
                    DispatchQueue.main.async {
                    self.homeTitle.text = self.titletext
                    self.homeTableview.reloadData()
                }
            }
        }
        
                
        }.resume()
                
//                print("menuModel count", menuModel?.body?.data?.count)
            }
    }


extension RootViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == menuTableview {
            return 2
        }
        else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableview {
            if section == 0 {
            return 1
        } else {
            return MenuData.count
    }
        }
        else {
            return homeData.count
        }
            
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTableview {
            if indexPath.section == 0 {
            if let cell = menuTableview.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell {
                    cell.delegate = self
            return cell
                }
            } else if indexPath.section == 1 {
                if let cell = menuTableview.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
    //                cell.menuTitle.text = MenuData[indexPath.row].title
                    cell.configureUI(menu: MenuData[indexPath.row])
                    return cell
                }
                
            }
        }
        else {
            if let cell = homeTableview.dequeueReusableCell(withIdentifier: "CarousalTableViewCell", for: indexPath) as? CarousalTableViewCell{
                cell.ConfigUI(playlist: homeData[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == menuTableview {
            if indexPath.section == 0{
                return 60
            } else {
              return 45
            }
        }
        else {
        return 200
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == menuTableview {
            
            print("selected Menu: ", MenuData[indexPath.row].title)
            if let id = MenuData[indexPath.row].id {
                menuTapped()
                if let data = allHomeData[String(id)]{
                    homeTitle.text = data.title
                    homeData = data.playlists ?? []
                    homeTableview.reloadData()
                    print("No Api call done")
                }
                else{
                self.getHomeData(homeid: String(id))
                    print("Api call done")
            
                }
                
            }
        }
    }
}




