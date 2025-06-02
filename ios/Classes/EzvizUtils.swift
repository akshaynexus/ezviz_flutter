//
//  EzvizUtils.swift
//  ezviz_flutter
//
//  Created by lixiaoling on 2019/8/26.
//

import Foundation

func objToJSONObject<T : Codable>(obj: T) -> [String:Any]? {
    let encoder = JSONEncoder()
    let data = try! encoder.encode(obj)
    return dataToDictionary(data: data)
}

func objToJSONString<T : Codable>(obj: T) -> String? {
    let encoder = JSONEncoder()
    let data = try! encoder.encode(obj)
    return  String(data: data, encoding: .utf8)
}

func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
    do{
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dic = json as! Dictionary<String, Any>
        return dic
    }catch _ {
        print("失败")
        return nil
    }
}
