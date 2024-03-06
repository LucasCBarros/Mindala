//
//  InputInfoExchangeProtocol.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 09/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation
import UIKit

protocol InuptInfoExchangeProtocol {
    func pushName(name: String)
    func pushStartDate(timestamp: Double)
    func pushDeadline(timestamp: Double)
    func pushWorkingDays(workingDays: [DayOfWeekEnum])
    func pushColor(color: UIColor)
    func pushIcon(iconIndex: Int)
    func pushNotificationList(reminders: [Double])
    func requestTask() -> Task
    func saveAndExit()
}
