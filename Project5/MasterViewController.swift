//
//  MasterViewController.swift
//  Project5
//
//  Created by Jacques on 27/11/15.
//  Copyright © 2015 J4SOFT. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController {

    var userAnswers = [String]()
    var allWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        
        allWords = loadWordsFromFile(NSBundle.mainBundle())
        startGame()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnswers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let userAnswer = userAnswers[indexPath.row]
        cell.textLabel!.text = userAnswer
        return cell
    }
    
    func loadWordsFromFile(bundle: NSBundle) -> [String] {
        let defaultResult = ["silkworm"]
        if let wordsFilePath = bundle.pathForResource("words", ofType: "txt") {
            if let wordsFileContent = try? String(contentsOfFile: wordsFilePath, usedEncoding: nil) {
                return wordsFileContent.componentsSeparatedByString("\n")
            }
        } else {
            return defaultResult
        }
        return defaultResult
    }
    
    func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        userAnswers.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)

        let submitAction = UIAlertAction(title: "Submit", style: .Default, handler: {
            [unowned self, alertController] (action: UIAlertAction!) in
                let answerTextField = alertController.textFields![0]
                self.submitAnswer(answerTextField.text!)
            }
        )
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func submitAnswer(value: String) {
        let lowercaseValue = value.lowercaseString
        if wordIsPossible(lowercaseValue) {
            if wordIsOriginal(lowercaseValue) {
                if wordIsReal(lowercaseValue) {
                    userAnswers.insert(value, atIndex: 0)
                    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    func wordIsPossible(value: String) -> Bool {
        return true
    }
    
    func wordIsOriginal(value: String) -> Bool {
        return true
    }
    
    func wordIsReal(value: String) -> Bool {
        return true
    }
}