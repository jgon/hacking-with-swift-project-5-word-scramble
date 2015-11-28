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

        let object = userAnswers[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }
    
    func loadWordsFromFile(bundle: NSBundle) -> [String] {
        let defaultResult = ["silkworm"]
        if let wordsFilePath = bundle.pathForResource("start", ofType: "txt") {
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

        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, alertController] (action: UIAlertAction!) in
            let answer = alertController.textFields![0]
            self.submitAnswer(answer.text!)
        }
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func submitAnswer(value: String) {
        
    }
}