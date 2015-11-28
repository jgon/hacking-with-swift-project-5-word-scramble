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
        if let wordsFilePath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            if let wordsFileContent = try? String(contentsOfFile: wordsFilePath, usedEncoding: nil) {
                allWords = wordsFileContent.componentsSeparatedByString("\n")
            }
        } else {
            allWords = ["silkworm"]
        }
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
    
    func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        userAnswers.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
}