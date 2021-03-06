//
//  SessionVC.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 7/10/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SessionVC: UIViewController {
    private let SIGNTOCHAT_SEGUE = "SignToChatSegue";
    static var sessionPath = Database.database().reference().child(Constants.SESSIONS).childByAutoId();
    private var continuingSession = false;
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSession();
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
    }
    
    func getSession() {
        Database.database().reference().child(Constants.SESSIONS).queryLimited(toLast: 1).observeSingleEvent(of: DataEventType.childAdded) {
            (snapshot: DataSnapshot) in
            SessionVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).child(snapshot.key);
            self.continuingSession = true;
        }
    }
    
    @IBAction func newSession(_ sender: Any) {
        SessionVC.sessionPath = Database.database().reference().child(Constants.SESSIONS).childByAutoId();
        self.performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
    }
    
    @IBAction func contSession(_ sender: Any) {
        if(self.continuingSession == true){
            self.performSegue(withIdentifier: self.SIGNTOCHAT_SEGUE, sender: nil);
        }
    }

    @objc func tick() {
        currentTimeLabel.text = DateFormatter.localizedString(from: Date(),
                                                              dateStyle: .medium,
                                                              timeStyle: .medium)
    }
}
