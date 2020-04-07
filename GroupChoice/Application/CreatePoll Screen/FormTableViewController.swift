//
//  FormTableViewController.swift
//  
//
//  Created by Oleksandr Gribov on 4/3/20.
//

import UIKit

class FormTableViewController: UITableViewController {
    private var voteDatePickerVisible = false
    private var eventDatePickerVisible = false
    private var endAtTimeOfEvent = true
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var voteDateLabel: UILabel!
    @IBOutlet weak var voteEndDateLabel: UILabel!
    @IBOutlet weak var voteEndLabel: UILabel!
    

    @IBAction func toggle(_ sender: Any) {
        endAtTimeOfEvent = !endAtTimeOfEvent
        if !endAtTimeOfEvent {
            voteDatePickerVisible = true
            showDatePicker(voteDatePicker)
            voteEndDateLabel.textColor = .black
            voteEndLabel.textColor = .black
        } else {
            voteDatePickerVisible = false
            hideDatePicker(voteDatePicker)
            voteEndDateLabel.textColor = .gray
            voteEndLabel.textColor = .gray
        }
    }
        
   
    @IBOutlet var voteDatePicker: UIDatePicker!
    
    @IBOutlet var eventDatePicker: UIDatePicker!
    
    @IBAction func doneButton(_ sender: Any) {
        print("Done clicked")
    }
    
    func setDateLabel(_ textLabel: UILabel, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        textLabel.text = dateFormatter.string(from: date)
        
    }
    
    @IBAction func voteDateChanged(_ sender: UIDatePicker) {
        setDateLabel(voteEndDateLabel, date: sender.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.voteDatePicker = UIDatePicker()
        self.eventDatePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.eventDateLabel.text = dateFormatter.string(from: eventDatePicker!.date)
        
        if endAtTimeOfEvent {
            voteEndDateLabel.text = dateFormatter.string(from: voteDatePicker!.date)
        }
        self.voteDatePicker.isHidden = true
        self.voteDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.eventDatePicker.isHidden = true
        self.eventDatePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func hideDatePicker(_ datePicker: UIDatePicker) {
        datePicker.isHidden = true
        if datePicker == voteDatePicker {
            self.voteDatePickerVisible = false
        } else {
            self.eventDatePickerVisible = false
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()

    }
    func showDatePicker (_ datePicker: UIDatePicker) {
        datePicker.isHidden = false
        if datePicker == voteDatePicker {
            self.voteDatePickerVisible = true
        } else {
            self.eventDatePickerVisible = true
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.alwaysBounceVertical = false
        eventDatePicker.datePickerMode = .dateAndTime
        voteDatePicker.datePickerMode = .dateAndTime
        
    }
    
    @IBAction func testing2(_ sender: UIDatePicker) {
        print("Testing: \(sender.date)")
        setDateLabel(eventDateLabel, date: sender.date)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  ( indexPath.section == 1 && indexPath.row == 0) {
                if voteDatePickerVisible {
                    hideDatePicker(voteDatePicker)
                } else {
                    showDatePicker(voteDatePicker)
                }
            }
        else if (indexPath.section == 0 && indexPath.row == 1) {
            if eventDatePickerVisible {
                hideDatePicker(eventDatePicker)
            } else {
                showDatePicker(eventDatePicker)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ( indexPath.section == 1 && indexPath.row == 2) {
                return voteDatePickerVisible ? 180 : 0
            }
        else if (indexPath.section == 0 && indexPath.row == 2) {
            return eventDatePickerVisible ? 180 : 0 
        }
        return 50
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

