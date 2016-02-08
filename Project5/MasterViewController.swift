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
        
        let showErrorMessage = { [unowned self] (title: String, message: String) in
            let errorMessageController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            errorMessageController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(errorMessageController, animated: true, completion: nil)
        }
        
        if answer.isEmpty {
            showErrorMessage("Missing answer", "You must provide an answer.")
            return
        }
        
        let lowercaseAnswer = answer.lowercaseString

        if !wordIsPossible(lowercaseAnswer) {
            showErrorMessage("Word not possible", "You can't spell '\(lowercaseAnswer)' from '\(title!.lowercaseString)'!")
            return
        }
        
        if !wordIsOriginal(lowercaseAnswer) {
            showErrorMessage("'\(answer)' word already used", "Be more original!")
            return
        }
        
        if !wordIsReal(lowercaseAnswer) {
            showErrorMessage("Unknown word '\(answer)'", "You can't just make words up, you know!")
            return
        }

        userAnswers.insert(answer, atIndex: 0)
        
        // Inserting a row in a table view with animation to provide a visual clue to the user about what is going on,
        // instead of reloading the whole table.
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func wordIsPossible(answer: String) -> Bool {
        var lowercaseWord = title!.lowercaseString
        for character in answer.characters {
            if let position = lowercaseWord.rangeOfString(String(character)) {
                lowercaseWord.removeAtIndex(position.startIndex)
            } else {
                return false
            }
        }
        return true
    }
    
    func wordIsOriginal(answer: String) -> Bool {
        return !userAnswers.contains(answer)
    }
    
    func wordIsReal(answer: String) -> Bool {
        let checker = UITextChecker()
        let checkRange = NSMakeRange(0, answer.characters.count)
        let range = checker.rangeOfMisspelledWordInString(answer, range: checkRange, startingAt: 0, wrap: false, language: "en")
        return range.location == NSNotFound
    }
}