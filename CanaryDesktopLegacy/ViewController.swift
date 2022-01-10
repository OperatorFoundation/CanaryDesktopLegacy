//
//  ViewController.swift
//  CanaryDesktopLegacy
//
//  Created by Mafalda on 10/19/21.
//

import Cocoa
import Foundation
import Network

import Canary

class ViewController: NSViewController
{
    @IBOutlet var loggerTextView: NSTextView!
    @IBOutlet weak var ipTextField: NSTextField!
    @IBOutlet weak var configDirectoryLabel: NSTextField!
    @IBOutlet weak var saveDirectoryLabel: NSTextField!

    @objc dynamic var timesToRun = 1
    var runningLog = globalRunningLog
    
    var isValidIP = false
    var isValidConfigPath = false
    var isValidSavePath = false
    
    private var serverIP = UserDefaults.standard.string(forKey: serverIPKey) ?? ""
    private var configPath = UserDefaults.standard.string(forKey: configPathKey) ?? "Config Directory Needed"
    private var savePath = UserDefaults.standard.string(forKey: savePathKey) ?? ""
    private var testCount = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configDirectoryLabel.stringValue = configPath
        isValidConfigPath = Validator.validate(configPath: configPath)
        
        ipTextField.stringValue = serverIP
    }
    
    
    
    // MARK: IBActions
    
    @IBAction func browseClicked(_ sender: NSButton)
    {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        if panel.runModal() == .OK
        {
            isValidConfigPath = Validator.validate(configURL: panel.url)
            
            if isValidConfigPath
            {
                configPath = panel.url!.path
                UserDefaults.standard.set(configPath, forKey: configPathKey)
            }
            else
            {
                configPath = ""
            }
            
            configDirectoryLabel.stringValue = configPath
        }
    }
    
    @IBAction func browseSavePathClicked(_ sender: NSButton)
    {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        if panel.runModal() == .OK
        {
            isValidSavePath = FileManager.default.fileExists(atPath: panel.url!.path)
            
            if isValidSavePath
            {
                savePath = panel.url!.path
                UserDefaults.standard.set(savePath, forKey: savePathKey)
            }
            else
            {
                savePath = ""
            }
            
            saveDirectoryLabel.stringValue = savePath
        }
    }
    
    @IBAction func runClicked(_ sender: NSButton)
    {
        isValidIP = true //Validator.validate(serverIP: serverIP)
                
        if (isValidIP)
        {
            UserDefaults.standard.set(serverIP, forKey: serverIPKey)
            
            if (isValidConfigPath)
            {
                var userSavePath: String?
                
                if (!savePath.isEmpty)
                {
                    userSavePath = savePath
                }
                
                runningLog.logString += "\nRunning Canary tests. This may take a few moments.\n"
                let canary = Canary(serverIP: ipTextField.stringValue, configPath: configPath, savePath: userSavePath, logger: uiLog, timesToRun: testCount, interface: nil)
                canary.runTest()
            }
            else
            {
                runningLog.logString += "\nFailed to run the requested tests, please check that the config directory you selected has the correct transport config files.\n"
            }
        }
        else
        {
            runningLog.logString += "\nFailed to run the requested tests, please check that you entered a valid IP address.\n"
        }
        
        loggerTextView.string = runningLog.logString
    }
}

