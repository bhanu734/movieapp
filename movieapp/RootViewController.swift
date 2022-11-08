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
        issetting = true
        menuTapped()
        homeTableview.reloadData()
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
//    var MenuData: [Menu] = []
//    var homeData: [Playlist] = []
    var titletext: String = ""
    var settingsData : [Setting] = []
    var issetting : Bool = false
    
//    var allHomeData : [String: HomeData] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableview.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        menuTableview.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        menuTableview.delegate = self
        menuTableview.dataSource = self
        homeviewwidth.constant = UIScreen.main.bounds.width
        
        homeTableview.register(UINib(nibName: "CarousalTableViewCell", bundle: nil), forCellReuseIdentifier: "CarousalTableViewCell")
        homeTableview.register(UINib(nibName: "settingitemTableViewCell", bundle: nil), forCellReuseIdentifier: "settingitemTableViewCell")
        homeTableview.delegate = self
        homeTableview.dataSource = self
        
        menuwidth.constant = menuViewWidth
        menuleading.constant = -menuViewWidth

        getMenuData()
        createSettingsdata()
    }
    func createSettingsdata () {
//        settingsData = []
        
        settingsData.append(Setting(title: "Account", caption: "sign into acess", settingtype: SettingType.account))
        settingsData.append(Setting(title: "Language", caption: "Change Interface language", settingtype: SettingType.language))
        settingsData.append(Setting(title: "My Actiivity", caption: "Manage your all activities", settingtype: SettingType.myactivity))
        settingsData.append(Setting(title: "Contact", caption: "Want to contact us?", settingtype: SettingType.contact))
        settingsData.append(Setting(title: "Terms of use", caption: "App Terms and Conditions", settingtype: SettingType.termsofuse))
        settingsData.append(Setting(title: "About us", caption: "Read usefull Information about App", settingtype: SettingType.aboutus))
        settingsData.append(Setting(title: "Privacy", caption: "Read all About Privacy Policy", settingtype: SettingType.privacy))
        settingsData.append(Setting(title: "App version", caption: "5.11 Version", settingtype: SettingType.AppVersion))
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
                AppData.shared.MenuData = menuModel?.body?.data ?? []
                
                if let homeId = AppData.shared.MenuData[0].id{
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
                    AppData.shared.homeData = homemodel.response?.data?.playlists ?? []
                    self.titletext = homemodel.response?.data?.title ?? ""
                    AppData.shared.allHomeData[homeid] = homemodel.response?.data
                   
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
            return AppData.shared.MenuData.count
    }
        }
        else {
            if issetting {
                return settingsData.count
            }else {
                return AppData.shared.homeData.count
            }
            
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
                    cell.configureUI(menu: AppData.shared.MenuData[indexPath.row])
                    return cell
                }
                
            }
        }
        else {
            if issetting {
                if let cell = homeTableview.dequeueReusableCell(withIdentifier: "settingitemTableViewCell", for: indexPath) as? settingitemTableViewCell {
                    cell.configureUI(setting: settingsData[indexPath.row])
                    return cell
                }
                
            } else {
                if let cell = homeTableview.dequeueReusableCell(withIdentifier: "CarousalTableViewCell", for: indexPath) as? CarousalTableViewCell{
                    cell.ConfigUI(playlist: AppData.shared.homeData[indexPath.row])
                    return cell
                }
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
            if issetting {
                return 70
            } else {
                return 200
            }
        
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == menuTableview {
            
            print("selected Menu: ", AppData.shared.MenuData[indexPath.row].title)
            if let id = AppData.shared.MenuData[indexPath.row].id {
                for i in 0..<AppData.shared.MenuData.count{
                    if i == indexPath.row {
                        AppData.shared.MenuData[i].isselected = true
                    } else {
                        AppData.shared.MenuData[i].isselected = false
                    }
                }
                
                menuTableview.reloadData()
                issetting = false
                menuTapped()
                if let data = AppData.shared.allHomeData[String(id)]{
                    homeTitle.text = data.title
                    AppData.shared.homeData = data.playlists ?? []
                    homeTableview.reloadData()
                    print("No Api call done")
                }
                else{
                self.getHomeData(homeid: String(id))
                    print("Api call done")
                }
                
            }
        } else {
            if issetting {
                if settingsData[indexPath.row].settingtype == .account {
                    print("Going to my account")
                }else if settingsData[indexPath.row].settingtype == .language {
                    print("Going to Language")
                }else if settingsData[indexPath.row].settingtype == .contact {
                    print("Going to contact")
                }else if settingsData[indexPath.row].settingtype == .aboutus {
                    print("Going to aboutus")
                }else if settingsData[indexPath.row].settingtype == .myactivity {
                    print("Going to myactivity")
                }else if settingsData[indexPath.row].settingtype == .termsofuse {
                    print("Going to termsofuse")
                }else if settingsData[indexPath.row].settingtype == .AppVersion {
                    print("Going to AppVersion ")
                }else if settingsData[indexPath.row].settingtype == .privacy {
                print("Going to privacy")
         }
      }
    }

  }
}

