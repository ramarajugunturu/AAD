//
//  SELocalStoreSharedManager.swift
//  SEiOS
//
//  Created by Harish Rathuri on 15/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import Foundation


class SEStoreSharedManager {
    
    // ----------------------------------------------------------------------------------------
    //MARK: Shared Instance
    // ----------------------------------------------------------------------------------------
    
    static var sharedInstance: SEStoreSharedManager = SEStoreSharedManager()
    private init() {
    }
    
    // Local Variables
    var accessToken: String = ""
    var jsonContentType = "application/json"

}

