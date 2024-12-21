//
//  MessageListViewController.swift
//  likelion12th_app
//
//  Created by 홍성주 on 12/22/24.
//

import UIKit

class MessageListViewController: UITableViewController {

    @IBOutlet var tvListView: UITableView!
    
    var messages: [Message] = [] // 메시지 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        guard let receiverName = UserManager.shared.userName else {
            print("User name not found")
            return
        }
        
        // 메시지 가져오기
        NetworkManager.shared.fetchReceivedMessages(for: receiverName) { result in
            switch result {
            case .success(let fetchedMessages):
                self.messages = fetchedMessages
                DispatchQueue.main.async {
                    self.tvListView.reloadData()  // 메시지 데이터가 업데이트된 후 collectionView 리로드
                }
            case .failure(let error):
                print("Failed to fetch messages: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = messages[indexPath.row].contents
        cell.textLabel?.text = messages[indexPath.row].sender
//        cell.imageView?.image = UIImage(named: messages[indexPath.row])
    
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let detailView = segue.destination as! MessageDetailViewController
            
            detailView.showDetailMessage(messages[indexPath.row])
            
        }
    }
    

}
