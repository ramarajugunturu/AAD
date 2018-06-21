//
//  SEGlobalConstant.swift
//  SEiOS
//
//  Created by Harish Rathuri on 15/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import Foundation

var username : String!

struct SEWebserviceClient {
    static let eventURL = "https://graph.microsoft.com/v1.0/me/events"
    static let filterMeetingURL = "https://graph.microsoft.com/v1.0/me/findMeetingTimes"
    static let attendeesListURL = "https://graph.microsoft.com/v1.0/users?$orderby=displayName"
    static let myMeetingListURL = "https://graph.microsoft.com/v1.0/me/calendar/events"
}

func getDate(dateString : String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.z"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "EEEE, MMM d"
    let string = dateFormatter.string(from: date!)
    return string
}

func getTime(dateString: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.z"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "hh:mm a"
    let string = dateFormatter.string(from: date!)
    return string
}

