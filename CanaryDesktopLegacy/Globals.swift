//
//  Globals.swift
//  CanaryDesktopLegacy
//
//  Created by Mafalda on 11/15/21.
//

import Foundation
import Logging

let serverIPKey = "ServerIP"
let configPathKey = "ConfigPath"
let savePathKey = "SavePath"

var uiLog = Logger(label: "org.OperatorFoundation.CanaryDesktopUI", factory: CanaryLogHandler.init)
var globalRunningLog = RunningLog()

class RunningLog: ObservableObject
{
    var logString: String = ""
}
