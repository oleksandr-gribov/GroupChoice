//
//  FormTableViewController.swift
//  
//
//  Created by Oleksandr Gribov on 4/3/20.
//

import UIKit

class FormTableViewController: UITableViewController, UITextFieldDelegate, SearchCompleteDelegate {
    
    weak var delegate:SearchCompleteDelegate?
    
    private var voteDatePickerVisible = false
    private var eventDatePickerVisible = false
    private var endAtTimeOfEvent = true
    let dateFormatter = DateFormatter()
    @IBOutlet weak var eventNameTF: UITextField!
    
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var voteEndDateLabel: UILabel!
    @IBOutlet var voteDatePicker: UIDatePicker!
    @IBOutlet var eventDatePicker: UIDatePicker!
    let sectionHeaderTitleArray = ["General", "Voting", "Add Places"]
    var placesAdded: [Place] = []
    var createVoteButtonEnabled = false
    
    
    let createVote: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(displayP3Red: 221/255, green: 106/255, blue: 104/255, alpha: 1.0)
        btn.setAttributedTitle(NSAttributedString(string: "Create Vote", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 22), NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        btn.layer.cornerRadius = 10
        btn.alpha = 0.5
        return btn
    }()
    
    let helperLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.text = "Plase add a name and options"
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        return lbl
    }()
    
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDatePickers()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavBar()
        
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.eventNameTF.delegate = self
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.eventDateLabel.text = dateFormatter.string(from: eventDatePicker!.date)
        self.voteEndDateLabel.text = dateFormatter.string(from: eventDatePicker!.date)
        
        self.eventNameTF.addTarget(self, action: #selector(toggleCreateButtonState), for: .editingChanged)
        self.createVote.addTarget(self, action: #selector(createVoteButtonTapped), for: .touchUpInside)
        
    }
    @objc func createVoteButtonTapped() {
        // if not enough info to create a vote display a message
        if !createVoteButtonEnabled {
            helperLabel.isHidden = false
        } else {
            let voteName = eventNameTF.text
            let eventDate = eventDatePicker.date
            let voteEndingDate = voteDatePicker.date
            let newVote = Vote(title: voteName!, dateOfEvent: eventDate, endingDate: voteEndingDate)
            newVote.choices = placesAdded
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupNavBar() {
        let largeTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 33)]
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20)]
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = largeTextAttributes
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 221/255, green: 106/255, blue: 104/255, alpha: 1.0)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 221/255, green: 106/255, blue: 104/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .white
    }
    func setupCollectionView() {
        self.placesCollectionView.delegate = self
        self.placesCollectionView.dataSource = self
        self.placesCollectionView.allowsSelection = true
        self.placesCollectionView.alwaysBounceHorizontal = true
        self.placesCollectionView.alwaysBounceHorizontal = false
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        
        placesCollectionView.register(SearchPlacesCollectionViewCell.self, forCellWithReuseIdentifier: "addPlacesCell")
    }
    
    
    func setUpDatePickers() {
        self.voteDatePicker = UIDatePicker()
        self.eventDatePicker = UIDatePicker()
        
        eventDatePicker.datePickerMode = .dateAndTime
        voteDatePicker.datePickerMode = .dateAndTime
        
        self.voteDatePicker.isHidden = true
        self.voteDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.eventDatePicker.isHidden = true
        self.eventDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    // MARK: - Date Picker methods
    
    @IBAction func voteDateChanged(_ sender: UIDatePicker) {
        setDateLabel(voteEndDateLabel, date: sender.date)
    }
    
    @IBAction func eventPickerDateChanged(_ sender: UIDatePicker) {
        setDateLabel(eventDateLabel, date: sender.date)
        if self.endAtTimeOfEvent {
            setDateLabel(voteEndDateLabel, date: sender.date)
        }
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
    
    //  MARK: - Text Field Methods
    
    @objc func toggleCreateButtonState() {
        if (placesAdded.count != 0) && eventNameTF.text != "" {
            helperLabel.isHidden = true
            createVoteButtonEnabled = true
            createVote.alpha = 1.0
        } else {
            createVoteButtonEnabled = false
            createVote.alpha = 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.eventNameTF.resignFirstResponder()
        return true
    }
    
    // MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if eventNameTF.isFirstResponder {
            eventNameTF.resignFirstResponder()
        }
        if  ( indexPath.section == 1 && indexPath.row == 1 ) {
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
        if (indexPath.section == 0 && indexPath.row == 2) {
            return eventDatePickerVisible ? 180 : 0
        }
        else if ( indexPath.section == 1 && indexPath.row == 2) {
            return voteDatePickerVisible ? 180 : 0
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            return endAtTimeOfEvent ? 0 : 50
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            return 150
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            return 200
        }
        return 60
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)) //set these values as necessary
        returnedView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 20, y: returnedView.frame.height/2, width: 200, height: 30))
        
        label.text = self.sectionHeaderTitleArray[section]
        label.textColor = UIColor(displayP3Red: 150/255, green: 211/255, blue: 255/255, alpha: 1.0)
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        returnedView.addSubview(label)
        
        return returnedView
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 2 && indexPath.row == 0 {
            
            cell.addSubview(placesCollectionView)
            placesCollectionView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            cell.addSubview(createVote)
            cell.addSubview(helperLabel)
            helperLabel.isHidden = true
            createVote.snp.makeConstraints { ( make) in
                make.center.equalToSuperview()
                make.height.equalTo(70)
                make.width.equalToSuperview().multipliedBy(0.6)
            }
            helperLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(30)
                make.width.equalToSuperview().multipliedBy(0.65)
                make.bottom.equalTo(createVote.snp.top).offset(-15)
            }
        }
        
        
        cell.textLabel!.font = UIFont(name: "AvenirNext-Bold", size: 17)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 2 {
            if indexPath.row != 1 {
                let additionalSeparatorThickness = CGFloat(2)
                let additionalSeparator = UIView(frame: CGRect(x: 20,
                                                               y: cell.frame.size.height - additionalSeparatorThickness,
                                                               width: cell.frame.size.width-40,
                                                               height: additionalSeparatorThickness))
                
                additionalSeparator.backgroundColor = UIColor(displayP3Red: 221/255, green: 106/255, blue: 104/255, alpha: 1.0)
                cell.addSubview(additionalSeparator)
            }
        }
        
    }
    let placesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    //MARK: - Helper methods
    func onDoneButtonPressed(_ placesAdded: [Place]) {
        self.placesAdded = placesAdded
        
        print("Delegate places added are now ")
        
        for item in placesAdded {
            print(item.name)
        }
        self.toggleCreateButtonState()
        self.tableView.reloadData()
        self.placesCollectionView.reloadData()
    }
    @IBAction func toggle(_ sender: Any) {
        endAtTimeOfEvent = !endAtTimeOfEvent
        if !endAtTimeOfEvent {
            voteDatePickerVisible = true
            showDatePicker(voteDatePicker)
        } else {
            voteDatePickerVisible = false
            hideDatePicker(voteDatePicker)
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setDateLabel(_ textLabel: UILabel, date: Date) {
        textLabel.text = dateFormatter.string(from: date)
    }
}

// MARK: - CollectionView methods

extension FormTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if placesAdded.count == 0 {
            return 1
        }
        return placesAdded.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPlacesCell", for: indexPath) as! SearchPlacesCollectionViewCell
        if indexPath.row == 0 {
            cell.nameLabel.text = "Add places"
            cell.imageView.image = UIImage(named: "add_more")
        }else {
            let place = placesAdded[indexPath.row-1]
            cell.setupData(place)
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = AddPlacesToVoteTableViewController() as! AddPlacesToVoteTableViewController
            vc.searchCompleteDelegate = self
            vc.placesAdded = self.placesAdded
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
