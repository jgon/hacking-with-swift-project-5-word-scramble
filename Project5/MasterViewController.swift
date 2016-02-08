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
    
    @IBAction func promptForAnswer(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default, handler: {
                // self and alertController are unowned references to prevent memory leaks in the closure (circular references).
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

    func submitAnswer(answer: String) {
        let lowercaseAnswer = answer.lowercaseString
        if wordIsPossible(lowercaseAnswer) &&
            wordIsOriginal(lowercaseAnswer) &&
            wordIsReal(lowercaseAnswer) {
                    userAnswers.insert(answer, atIndex: 0)
                
                    // Inserting a row in a table view with animation to provide a visual clue to the user about what is going on.
                    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func wordIsPossible(answer: String) -> Bool {
        return true
    }
    
    func wordIsOriginal(answer: String) -> Bool {
        return true
    }
    
    func wordIsReal(answer: String) -> Bool {
        return true
    }
}