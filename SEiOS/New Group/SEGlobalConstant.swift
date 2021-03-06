//
//  SEGlobalConstant.swift
//  SEiOS
//
//  Created by Harish Rathuri on 15/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

var username : String!
var userDesignation : String!
var nextLink : String!
var userProfilePicture : UIImage!
var timezone : String = "UTC"

struct SEWebserviceClient {
    static let eventURL = "https://graph.microsoft.com/v1.0/me/events"
    static let filterMeetingURL = "https://graph.microsoft.com/v1.0/me/findMeetingTimes"
    static let findRoomListURL = "https://graph.microsoft.com/beta/me/findRooms"
    static let attendeesListURL = "https://graph.microsoft.com/v1.0/users?$orderby=displayName"
    static let myMeetingListURL = "https://graph.microsoft.com/v1.0/me/calendar/events"
    static let myProfilePictureURL = "https://graph.microsoft.com/beta/me/photo/$value"
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

func getLocalTimeZone() -> String {
    return TimeZone.current.identifier
}

