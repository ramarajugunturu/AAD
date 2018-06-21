//
//  SEWebServiceAPI.swift
//  SEiOS
//
//  Created by Harish Rathuri on 15/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import Foundation
import Alamofire

enum ErrorCode :String, Error{
    
    case Unauthorized = "401"
    case Forbidden = "403"
    case NotFound = "404"
    case MethodNotAllowed = "405"
    case NotAcceptable = "406"
    case Gone = "410"
    case InternalServerError = "500"
    case UnexpectedServerError = "501"
    
}

class ErrorHandler : NSObject{
    
    var responseMessage :String!
    var stausCode:String!
    var status :String!
    var newErrorCode:String!
    
    class func handleError(responseDictionary:[String:Any])-> ErrorHandler
    {
        let errorHandlerObj = ErrorHandler()
        var statusCode : String?
        if let statusCode_Str = responseDictionary["StatusCode"] as? String
        {
            statusCode = responseDictionary["StatusCode"] as! String
        }
        else if let statusCode_Str = responseDictionary["StatusCode"] as? Int
        {
            statusCode = "\(responseDictionary["StatusCode"] as! Int)"
        }
        //----
        
        
        errorHandlerObj.responseMessage = responseDictionary["Message"] as! String
        errorHandlerObj.stausCode = statusCode
        errorHandlerObj.status = responseDictionary["Status"] as! String
        
        
        if(statusCode == "400.1")
        {
            errorHandlerObj.newErrorCode = ErrorCode.Unauthorized.rawValue//"401"
        }
        else if (statusCode == "400.3")
        {
            errorHandlerObj.newErrorCode = ErrorCode.Forbidden.rawValue//"403"
        }
        else if (statusCode == "400.4")
        {
            errorHandlerObj.newErrorCode = ErrorCode.NotFound.rawValue//"404"
        }
        else if (statusCode == "400.5")
        {
            errorHandlerObj.newErrorCode = ErrorCode.MethodNotAllowed.rawValue//"405"
        }
        else if (statusCode == "500")
        {
            errorHandlerObj.newErrorCode = ErrorCode.InternalServerError.rawValue//"500"
        }
        else if (statusCode == "500.1")
        {
            errorHandlerObj.newErrorCode = ErrorCode.UnexpectedServerError.rawValue//"501"
        }
        else{
            errorHandlerObj.newErrorCode = statusCode
        }
        
        return errorHandlerObj
        
    }
    
    
}


class SEWebServiceAPI: NSObject {
    
    
    func filterMeetingSlots(url:String, parameters: Parameters, onSuccess:@escaping(_ response: Any) ->Void, onError:@escaping(_ error:NSError)->Void) {
        let headers: HTTPHeaders = ["Content-Type": SEStoreSharedManager.sharedInstance.jsonContentType,
                                    "Authorization": "Bearer \(SEStoreSharedManager.sharedInstance.accessToken)"]
       
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters , encoding: JSONEncoding.default, headers: headers).responseString(completionHandler:{
            response in
            if response.response != nil
            {
                if response.result.isSuccess {
                    
                    if let data = response.result.value!.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? Dictionary<String,Any>
                            print("json response: \(String(describing: json))")
                            
                            //-- success 200 condition
                            if response.response!.statusCode == 200
                            {
                                let response = json as! Dictionary<String,Any>
                                onSuccess(response)
                                
                                
                            }
                            else if(response.response!.statusCode < 200 || response.response!.statusCode > 300)
                            {
                                let erroHandlerObj = ErrorHandler.handleError(responseDictionary: json!)
                                onSuccess(erroHandlerObj.responseMessage)
                            }
                            else{
                                //onSuccess(messageStr!)
                                onSuccess("")
                            }
                            
                        } catch {
                            onSuccess("Some thing went wrong!")
                        }
                    }
                }//failure
                else{
                    onError(response.result.error! as NSError)
                }
            }
            else
            {
                onError(response.result.error! as NSError)
            }
        })
        
    }

    // ----------------------------------------------------------------------------------------
    // MARK: - Get
    // ----------------------------------------------------------------------------------------
    func createEventAPI(url:String, parameters: Parameters, onSuccess:@escaping(_ response: Any) ->Void, onError:@escaping(_ error:NSError)->Void) {
        let headers: HTTPHeaders = ["Content-Type": SEStoreSharedManager.sharedInstance.jsonContentType,
                                    "Authorization": "Bearer \(SEStoreSharedManager.sharedInstance.accessToken)"]
        
        print(url)
        print(parameters)
        print(headers)
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters , encoding: JSONEncoding.default, headers: headers).responseString(completionHandler:{
            response in
            if response.response != nil
            {
                if response.result.isSuccess {
                    
                    if let data = response.result.value!.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String:Any]
                            print("json response: \(String(describing: json))")
                            //let status = json?["Status"] as? String
                            //let messageStr = json?["Message"] as? String
                            
                            //-- success 200 condition
                            if response.response!.statusCode == 200
                            {
                                onSuccess("Event created successfully!")
                                /*
                                let jsonConditions : NSMutableDictionary = json?["Data"] as! NSMutableDictionary
                                let statusMsg = json?["Status"] as! String
                                
                                if statusMsg == "Success"
                                {
                                    onSuccess(jsonConditions as NSMutableDictionary)
                                }
                                else{
                                    onSuccess("Event created successfully!")
                                    
                                }*/
                                
                                
                            }
                            else if(response.response!.statusCode < 200 || response.response!.statusCode > 300)
                            {
                                let erroHandlerObj = ErrorHandler.handleError(responseDictionary: json!)
                                onSuccess(erroHandlerObj.responseMessage)
                            }
                            else{
                                //onSuccess(messageStr!)
                                onSuccess("")
                            }
                            
                        } catch {
                            onSuccess("Some thing went wrong!")
                        }
                    }
                }//failure
                else{
                    onError(response.result.error! as NSError)
                    
                }
            }
            else
            {
                onError(response.result.error! as NSError)
            }
        })
        
    }
    
    
    func getAttendeesList(url:String, onSuccess:@escaping(_ response: Any) ->Void, onError:@escaping(_ error:NSError)->Void) {
        let headers: HTTPHeaders = ["Content-Type": SEStoreSharedManager.sharedInstance.jsonContentType,
                                    "Authorization": "Bearer \(SEStoreSharedManager.sharedInstance.accessToken)"]
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil , encoding: JSONEncoding.default, headers: headers).responseString(completionHandler:{
            response in
            if response.response != nil
            {
                if response.result.isSuccess {
                    
                    if let data = response.result.value!.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String:Any]
                            
                            //-- success 200 condition
                            if response.response!.statusCode == 200
                            {
                                var userDataSource = Array<SEAttendeeUserModel>()
                                let jsonDict = json as! Dictionary<String, Any>
                                let value = jsonDict["value"] as? Array<Any>
                                if value != nil {
                                    for item in value! {
                                        let result =  item as! Dictionary<String, Any>
                                        let modObj = SEAttendeeUserModel()
                                        modObj.id = result["id"] as? String
                                        modObj.businessPhones = result["businessPhones"] as? Array
                                        modObj.displayName = result["displayName"] as? String
                                        modObj.givenName = result["givenName"] as? String
                                        modObj.jobTitle = result["jobTitle"] as? String
                                        modObj.mail = result["mail"] as? String
                                        modObj.mobilePhone = result["mobilePhone"] as? String
                                        modObj.officeLocation = result["officeLocation"] as? String
                                        modObj.preferredLanguage = result["preferredLanguage"] as? String
                                        modObj.surname = result["surname"] as? String
                                        modObj.userPrincipalName = result["userPrincipalName"] as? String
                                        userDataSource.append(modObj)
                                    }
                                    onSuccess(userDataSource)
                                }
                            }
                            else if(response.response!.statusCode < 200 || response.response!.statusCode > 300)
                            {
                                let erroHandlerObj = ErrorHandler.handleError(responseDictionary: json!)
                                onSuccess(erroHandlerObj.responseMessage)
                            }
                            else{
                                //onSuccess(messageStr!)
                                onSuccess("")
                            }
                            
                        } catch {
                            onSuccess("Some thing went wrong!")
                        }
                    }
                }//failure
                else{
                    onError(response.result.error! as NSError)
                    
                }
            }
            else
            {
                onError(response.result.error! as NSError)
            }
        })
        
    }
    
    func getMyMeetingList(url:String, onSuccess:@escaping(_ response: Any) ->Void, onError:@escaping(_ error:NSError)->Void) {
        let headers: HTTPHeaders = ["Content-Type": SEStoreSharedManager.sharedInstance.jsonContentType,
                                    "Authorization": "Bearer \(SEStoreSharedManager.sharedInstance.accessToken)"]
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil , encoding: JSONEncoding.default, headers: headers).responseString(completionHandler:{
            response in
            if response.response != nil
            {
                if response.result.isSuccess {
                    
                    if let data = response.result.value!.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String:Any]
                            
                            //-- success 200 condition
                            if response.response!.statusCode == 200
                            {
                                var userDataSource = [SEMyMeetingModel]()
                                let jsonDict = json as! Dictionary<String, Any>
                                let value = jsonDict["value"] as? Array<Any>
                                for item in value!{
                                    let resultItem = item as! Dictionary<String,Any>
                                    let modObj = SEMyMeetingModel()
                                    modObj.subject = resultItem["subject"] as! String
                                    let dateTimeDict = resultItem["start"] as! Dictionary<String,Any>
                                    modObj.dateTime = dateTimeDict["dateTime"] as! String
                                    modObj.date = getDate(dateString: modObj.dateTime)
                                    modObj.time = getTime(dateString: modObj.dateTime)
                                    let locationDict = resultItem["location"] as! Dictionary<String,Any>
                                    modObj.location = locationDict["displayName"] as! String
                                    let attendeesArray = resultItem["attendees"] as! Array<Dictionary<String,Any>>
                                    for item1 in attendeesArray{
                                        let emailDict = item1["emailAddress"] as! Dictionary<String,Any>
                                        let name = emailDict["name"] as! String
                                        modObj.attendeesName.append(name)
                                    }
                                   userDataSource.append(modObj)
                                    
                                }
                                onSuccess(userDataSource)
                                
                            }
                            else if(response.response!.statusCode < 200 || response.response!.statusCode > 300)
                            {
                                let erroHandlerObj = ErrorHandler.handleError(responseDictionary: json!)
                                onSuccess(erroHandlerObj.responseMessage)
                            }
                            else{
                                //onSuccess(messageStr!)
                                onSuccess("")
                            }
                            
                        } catch {
                            onSuccess("Some thing went wrong!")
                        }
                    }
                }//failure
                else{
                    onError(response.result.error! as NSError)
                    
                }
            }
            else
            {
                onError(response.result.error! as NSError)
            }
        })
        
    }
}


