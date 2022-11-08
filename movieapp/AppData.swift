//
//  AppData.swift
//  movieapp
//
//  Created by Mac on 06/11/22.
//

import Foundation

class AppData {
    static var shared: AppData = AppData()
    
    var MenuData: [Menu] = []
    var homeData: [Playlist] = []
    var allHomeData : [String: HomeData] = [:]
}
