//
//  EHRListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class Disease {
    var checked : Bool?
    var data : String?
    var name : String?
    
    init() {
        checked = false
        data = ""
        name = ""
    }
    
    init(_checked: Bool, _data:String, _name:String) {
        checked = _checked
        data = _data
        name = _name
    }
    
    func updateModelUsingDict(_ dict: [String:Any]){
        if let check1 = dict["checked"] as? Bool{
            checked = check1
        }
        
        if let data1 = dict["data"] as? String{
            data = data1
        }
        
        if let name1 = dict["name"] as? String{
            name = name1
        }
        
        if let timeData = dict["time_data"] as? String{
            data = timeData
        }
    }
}

class BMIModel{
    var feet : Int?
    var inch : Int?
    var upperBloodPressure : Int?
    var lowerBloodPressure : Int?
    var weight : Int?
    var bmi : Int?
    
    init() {
        feet = 0
        inch = 0
        upperBloodPressure = 0
        lowerBloodPressure = 0
        weight = 0
        bmi = 0
    }
    
    init(_feet:Int, _inch:Int, _upBlood:Int, _lowBlood:Int, _weight:Int) {
        feet = _feet
        inch = _inch
        upperBloodPressure = _upBlood
        lowerBloodPressure = _lowBlood
        weight = _weight
        bmi = 0
        
        self.calculateBMI()
    }
    
    func calculateBMI(){
        //bmi calculation
        let heightInches = (self.feet! * 12) + self.inch!
        
        if heightInches > 0{
            let calculatedBmi = 703 * weight! / (heightInches * heightInches)
            self.bmi = calculatedBmi
        }
    }
}

class EHRListVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    let cellID_lifeStyle = "cellID_lifeStyle"
    let cellID_currentMedicine = "cellID_currentMedicine"
    let cellID_avoidMedicine = "cellID_avoidMedicine"
    let cellID_disease = "cellID_disease"
    let cellID_pregnantHistroy = "cellID_pregnantHistroy"
    
    var bmiData = BMIModel(_feet: 0, _inch: 0, _upBlood: 0, _lowBlood: 0, _weight: 0)
    
    var avoidMedicineList = [Disease]()
    var currentMedicineList = [Disease]()
    
    var lifeStyleList = [Disease.init(_checked: false, _data: "", _name: "ရာသီတုပ်ကွေးကာကွယ်ဆေးထိုးလေ့ရိုပါသလား?"),
                         Disease.init(_checked: false, _data: "", _name: "ဆေးလိပ်သောက်ပါသလား?"),
                         Disease.init(_checked: false, _data: "", _name: "အရက်သောက်ပါသလား?"),
                         Disease.init(_checked: false, _data: "", _name: "ကွမ်းစားပါသလား?")]
    
    var diseasesList = [Disease(_checked: false, _data: "1990", _name: "သွေးတိုး"),
                        Disease(_checked: false, _data: "1990", _name: "နှလုံး"),
                        Disease(_checked: false, _data: "1990", _name: "ဆီးချို"),
                        Disease(_checked: false, _data: "1990", _name: "ပန်းနာ၊ ရင်ကျပ်"),
                        Disease(_checked: false, _data: "1990", _name: "တီဘီ"),
                        Disease(_checked: false, _data: "1990", _name: "လေးဘက်နာ"),
                        Disease(_checked: false, _data: "1990", _name: "အစာအိမ်အနာ"),
                        Disease(_checked: false, _data: "1990", _name: "ကင်ဆာ"),
                        Disease(_checked: false, _data: "1990", _name: "လေဖြတ်"),
                        Disease(_checked: false, _data: "1990", _name: "ကျောက်ကပ်"),
                        Disease(_checked: false, _data: "1990", _name: "အတွင်းတိမ် (မျက်စိ)")]
    var sortedDiseaseList = [Disease]()
    
    var surgeryList = [Disease(_checked: false, _data: "1990", _name: "ဦးခေါင်း"),
                       Disease(_checked: false, _data: "1990", _name: "မျက်စိ"),
                       Disease(_checked: false, _data: "1990", _name: "နား၊ နှာခေါင်း၊ လည်ချောင်း"),
                       Disease(_checked: false, _data: "1990", _name: "အဆုတ်"),
                       Disease(_checked: false, _data: "1990", _name: "နှလုံး"),
                       Disease(_checked: false, _data: "1990", _name: "ရင်သားအကျိတ်"),
                       Disease(_checked: false, _data: "1990", _name: "အစာအိမ်၊ အူလမ်းကြောင်း၊ အူအတက်"),
                       Disease(_checked: false, _data: "1990", _name: "ကျောက်ကပ်"),
                       Disease(_checked: false, _data: "1990", _name: "သည်းခြေအိတ်"),
                       Disease(_checked: false, _data: "1990", _name: "ဘေလုံး"),
                       Disease(_checked: false, _data: "1990", _name: "သားအိမ်"),
                       Disease(_checked: false, _data: "1990", _name: "လိပ်ခေါင်း၊ ဂရင်ဂျီနာ")]
    var sortedSurgeryList = [Disease]()
    
    var familyHistory = [Disease(_checked: false, _data: "မိဘများ", _name: "ပန်းနာရင်ကျပ်"),
                         Disease(_checked: false, _data: "မိဘများ", _name: "ကင်ဆာ"),
                         Disease(_checked: false, _data: "မိဘများ", _name: "မျိုးရိုးဗီဇနှင့်ဆိုင်သောရောဂါ"),
                         Disease(_checked: false, _data: "မိဘများ", _name: "နှလုံးရောဂါ"),
                         Disease(_checked: false, _data: "မိဘများ", _name: "သွေးတိုး"),
                         Disease(_checked: false, _data: "မိဘများ", _name: "ဆီးချို")]
    var sortedFamilyHistory = [Disease]()
    
    var pregnantHistory = [Disease(_checked: false, _data: "", _name: "လက်ရှိကိုယ်ဝန်ဆောင်နေပါသလား?"),
                           Disease(_checked: false, _data: "0", _name: "သားသမီးဦးရေ (ရှိပါက)")]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Medical Book", style: .plain, target: self, action: #selector(showMedicalRecord))
        
        setupViews()
        
        if let userID = UserDefaults.standard.getUserData().object(forKey: "_id") as? String{
            getEhrDataByUserID(userID)
        }
    }
    
    @objc func showMedicalRecord(){
        self.navigationController?.pushViewController(RecordBookVC(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sortArrays()
    }
    
    func setupViews(){
        self.title = "ကျန်းမာရေးမှတ်တမ်းများ"
        let newBackButton = UIBarButtonItem(title: "<Back", style: .plain, target: self, action: #selector(backButtonClick))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.register(PatientInfoCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(LifeStyleCellCollectionView.self, forCellWithReuseIdentifier: cellID_lifeStyle)
        collectionView.register(CurrentMedicineCellCollectionView.self, forCellWithReuseIdentifier: cellID_currentMedicine)
        collectionView.register(AvoidMedicineCellCollectionView.self, forCellWithReuseIdentifier: cellID_avoidMedicine)
        collectionView.register(DiseaseCellCollectionView.self, forCellWithReuseIdentifier: cellID_disease)
        collectionView.register(PrefnantHistoryCell.self, forCellWithReuseIdentifier: cellID_pregnantHistroy)
    }
    
    
    @objc func backButtonClick(){
        let alert = UIAlertController(title: "Do you want to save your medical records?", message: "Please click save button to save your data on server.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if let userID = UserDefaults.standard.getUserData().object(forKey: "_id") as? String{
                self.uploadEhrToServerByUserID(userID)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    func sortArrays(){
        sortedDiseaseList.removeAll()
        for d in diseasesList{
            if d.checked!{
                sortedDiseaseList.append(d)
            }
        }
        
        sortedSurgeryList.removeAll()
        for s in surgeryList{
            if s.checked!{
                sortedSurgeryList.append(s)
            }
        }
        
        sortedFamilyHistory.removeAll()
        for f in familyHistory{
            if f.checked!{
                sortedFamilyHistory.append(f)
            }
        }
        
        collectionView.reloadData()
    }
}

extension EHRListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if indexPath.row == 0{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PatientInfoCell
            cell1.bmiInfoData = self.bmiData
            cell1.ehrVC = self
            cell = cell1
        }else if indexPath.row == 1{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_lifeStyle, for: indexPath) as! LifeStyleCellCollectionView
            cell1.ehrVC = self
            cell1.lifeStyleList = self.lifeStyleList
            cell = cell1
        }
        else if indexPath.row == 2{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_currentMedicine, for: indexPath) as! CurrentMedicineCellCollectionView
            cell1.ehrVC = self
            cell1.medicines = self.currentMedicineList
            cell1.collectionView.reloadData()
            cell = cell1
        }
        else if indexPath.row == 3{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_avoidMedicine, for: indexPath) as! AvoidMedicineCellCollectionView
            cell1.ehrVC = self
            cell1.medicines = self.avoidMedicineList
            cell1.collectionView.reloadData()
            cell = cell1
        }
        else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_disease, for: indexPath) as! DiseaseCellCollectionView
            
            if indexPath.row == 4{
                cell1.titlelabel.text = "ရောဂါအခံများ"
                cell1.dataList = self.sortedDiseaseList
                cell1.diseaseList = self.diseasesList
                cell1.ehrVC = self
                cell1.type = "disease"
                cell1.collectionView.reloadData()
                
            } else if indexPath.row == 5{
                cell1.titlelabel.text = "ခွဲစိတ်ကုသခဲ့မူများ"
                cell1.dataList = self.sortedSurgeryList
                cell1.diseaseList = self.surgeryList
                cell1.ehrVC = self
                cell1.type = "surgery"
                cell1.collectionView.reloadData()
                
            } else if indexPath.row == 6{
                cell1.titlelabel.text = "မိသားစုကျန်းမာရေးရာဇဝင်"
                cell1.dataList = self.sortedFamilyHistory
                cell1.diseaseList = self.familyHistory
                cell1.ehrVC = self
                cell1.type = "family"
                cell1.collectionView.reloadData()
            }
            cell1.ehrVC = self
            cell = cell1
        }
        else if indexPath.row == 7{
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_pregnantHistroy, for: indexPath) as! PrefnantHistoryCell
            cell1.ehrVC = self
            cell1.dataList = self.pregnantHistory
            cell = cell1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 220
        if indexPath.row == 1 {
            height = 330
        }
        else if indexPath.row == 1{
            let cellsHeight = 45 * lifeStyleList.count
            height = CGFloat(cellsHeight + 90)
        }
        else if indexPath.row == 2{
            let cellsHeight = 55 * currentMedicineList.count
            height = CGFloat(cellsHeight + 90)
        }
        else if indexPath.row == 3{
            let cellsHeight = 55 * avoidMedicineList.count
            height = CGFloat(cellsHeight + 70)
        }
        else if indexPath.row == 4{
            let cellsHeight = 30 * sortedDiseaseList.count
            height = CGFloat(cellsHeight + 70)
        }
        else if indexPath.row == 5{
            let cellsHeight = 30 * sortedSurgeryList.count
            height = CGFloat(cellsHeight + 70)
        }
        else if indexPath.row == 6{
            let cellsHeight = 30 * sortedFamilyHistory.count
            height = CGFloat(cellsHeight + 70)
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

extension EHRListVC{
    func uploadEhrToServerByUserID(_ userID:String){
        //base_disease : checked, data, name
        //current_drink_medicine : name, time_data
        //family_hr_record : checked, data, name
        //down_blood_pressure, upper_blood_pressure, feet, inches, weight
        //normal_records : checked, name
        //poison_medicine : name, time_data
        //your_operations : checked, name, data
        //ehr -> json string key
        
        self.startAnimating()
        
        let json = ["base_disease" : self.getBaseDiseasesUploadData(),
                    "current_drink_medicine" : self.getCurrentDrinkMedicineUploadData(),
                    "family_hr_record" : self.getFamilyHrRecordUploadData(),
                    "normal_records" : self.getNormalRecordUploadData(),
                    "poison_medicine" : self.poisonMedicineRecordUploadData(),
                    "your_operations" : self.operationUploadData(),
                    "down_blood_pressure" : "\(self.bmiData.lowerBloodPressure!)",
            "upper_blood_pressure" : "\(self.bmiData.upperBloodPressure!)",
            "feet" : "\(self.bmiData.feet!)",
            "inches" : "\(self.bmiData.inch!)",
            "weight" : "\(self.bmiData.weight!)"
            ] as [String : Any]
        
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            let params = ["ehr":convertedString!] as [String : Any]
            let heads = ["Authorization" : "\(jwtTkn)"]
            let url = EndPoints.uploadEhrDataByUser(userID).path
            
            Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                
                switch response.result{
                case .success:
                    let responseStatus = response.response?.statusCode
                    if responseStatus == 200 || responseStatus == 201{
                        print("upload ehr success")
                    } else {
                        print("failed to upload ehr")
                    }
                case .failure(let error):
                    print("\(error)")
                }
                self.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
            
            
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    func getJsonStringForUploadEhr() -> String{
        
        var jsonString = ""
        
        let json = ["base_disease" : self.getBaseDiseasesUploadData(),
                    "current_drink_medicine" : self.getCurrentDrinkMedicineUploadData(),
                    "family_hr_record" : self.getFamilyHrRecordUploadData(),
                    "normal_records" : self.getNormalRecordUploadData(),
                    "poison_medicine" : self.poisonMedicineRecordUploadData(),
                    "your_operations" : self.operationUploadData(),
                    "down_blood_pressure" : "\(self.bmiData.lowerBloodPressure!)",
            "upper_blood_pressure" : "\(self.bmiData.upperBloodPressure!)",
            "feet" : "\(self.bmiData.feet!)",
            "inches" : "\(self.bmiData.inch!)",
            "weight" : "\(self.bmiData.weight!)"
            ] as [String : Any]
        
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            jsonString = convertedString!
            
            
        } catch let myJSONError {
            print(myJSONError)
        }
        
        return jsonString
    }
    
    func getEhrDataByUserID2(_ userID:String){
        
        self.startAnimating()
        let url = EndPoints.getEhrDataByUser(userID).path
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case  .success:
                let reponseStatus = response.response?.statusCode
                if reponseStatus == 201 || reponseStatus == 200{
                    
                    if let responseDict = response.result.value as? [String:Any]{
                        if let baseDiseaseArrData = responseDict["base_diseases"] as? NSArray{
                            var baseDiseaseArr = [Disease]()
                            
                            for bd in baseDiseaseArrData{
                                if let baseDiseaseDict = bd as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(baseDiseaseDict)
                                    
                                    baseDiseaseArr.append(disease)
                                }
                            }
                            if baseDiseaseArr.count > 0{
                                self.diseasesList = baseDiseaseArr
                            }
                        }
                        
                        if let currentDrinkMedArrData = responseDict["current_drink_medicine"] as? NSArray{
                            var currentDrinkMedArr = [Disease]()
                            for med in currentDrinkMedArrData{
                                if let currentDrinkMedDict = med as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(currentDrinkMedDict)
                                    
                                    currentDrinkMedArr.append(disease)
                                }
                            }
                            if currentDrinkMedArr.count > 0{
                                self.currentMedicineList = currentDrinkMedArr
                            }
                        }
                        
                        if let poisonMedArrData = responseDict["poison_medicine"] as? NSArray{
                            var poisonMedArr = [Disease]()
                            for med in poisonMedArrData{
                                if let poisonMedDict = med as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(poisonMedDict)
                                    
                                    poisonMedArr.append(disease)
                                }
                            }
                            if poisonMedArr.count > 0{
                                self.avoidMedicineList = poisonMedArr
                            }
                        }
                        
                        if let normalRecordData = responseDict["normal_records"] as? NSArray{
                            var normalRecordArr = [Disease]()
                            for nr in normalRecordData{
                                if let normalRecordDict = nr as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(normalRecordDict)
                                    
                                    normalRecordArr.append(disease)
                                }
                            }
                            if normalRecordArr.count > 0{
                                self.lifeStyleList = normalRecordArr
                            }
                        }
                        
                        if let yourOperationsData = responseDict["your_operations"] as? NSArray{
                            var currentDrinkMedArr = [Disease]()
                            for med in yourOperationsData{
                                if let currentDrinkMedDict = med as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(currentDrinkMedDict)
                                    
                                    currentDrinkMedArr.append(disease)
                                }
                            }
                            if currentDrinkMedArr.count > 0{
                                self.surgeryList = currentDrinkMedArr
                            }
                        }
                        
                        if let yourOperationsData = responseDict["your_operations"] as? NSArray{
                            var currentDrinkMedArr = [Disease]()
                            for med in yourOperationsData{
                                if let currentDrinkMedDict = med as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(currentDrinkMedDict)
                                    
                                    currentDrinkMedArr.append(disease)
                                }
                            }
                            if currentDrinkMedArr.count > 0{
                                self.surgeryList = currentDrinkMedArr
                            }
                        }
                        
                        if let familyHrData = responseDict["family_hr_record"] as? NSArray{
                            var currentDrinkMedArr = [Disease]()
                            for med in familyHrData{
                                if let currentDrinkMedDict = med as? [String:Any]{
                                    
                                    let disease = Disease()
                                    disease.updateModelUsingDict(currentDrinkMedDict)
                                    
                                    currentDrinkMedArr.append(disease)
                                }
                            }
                            if currentDrinkMedArr.count > 0{
                                self.familyHistory = currentDrinkMedArr
                            }
                            
                        }
                    }
                    
                } else {
                    print("Failed to get data for ehr")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func getEhrDataByUserID(_ userID:String){
        
        self.startAnimating()
        let url = EndPoints.getEhrDataByUser(userID).path
        let heads = ["Authorization" : "\(jwtTkn)"]

        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case  .success:
                let reponseStatus = response.response?.statusCode
                if reponseStatus == 201 || reponseStatus == 200{
                    
                    if let responseString = response.result.value as? String{
                        
                        if let data = responseString.data(using: .utf8){
                            do{
                                if let responseDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                                    
                                    if let baseDiseaseArrData = responseDict["base_diseases"] as? NSArray{
                                        var baseDiseaseArr = [Disease]()
                                        
                                        for bd in baseDiseaseArrData{
                                            if let baseDiseaseDict = bd as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(baseDiseaseDict)
                                                
                                                baseDiseaseArr.append(disease)
                                            }
                                        }
                                        self.diseasesList = baseDiseaseArr
                                        self.sortArrays()
                                    }
                                    
                                    if let currentDrinkMedArrData = responseDict["current_drink_medicine"] as? NSArray{
                                        var currentDrinkMedArr = [Disease]()
                                        for med in currentDrinkMedArrData{
                                            if let currentDrinkMedDict = med as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(currentDrinkMedDict)
                                                
                                                currentDrinkMedArr.append(disease)
                                            }
                                        }
                                        self.currentMedicineList = currentDrinkMedArr
                                        self.sortArrays()
                                    }
                                    
                                    if let poisonMedArrData = responseDict["poison_medicine"] as? NSArray{
                                        var poisonMedArr = [Disease]()
                                        for med in poisonMedArrData{
                                            if let poisonMedDict = med as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(poisonMedDict)
                                                
                                                poisonMedArr.append(disease)
                                            }
                                        }
                                        self.avoidMedicineList = poisonMedArr
                                        self.sortArrays()
                                    }
                                    
                                    if let normalRecordData = responseDict["normal_records"] as? NSArray{
                                        var normalRecordArr = [Disease]()
                                        for nr in normalRecordData{
                                            if let normalRecordDict = nr as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(normalRecordDict)
                                                
                                                normalRecordArr.append(disease)
                                            }
                                        }
                                        self.lifeStyleList = normalRecordArr
                                        self.sortArrays()
                                    }
                                    
                                    if let yourOperationsData = responseDict["your_operations"] as? NSArray{
                                        var currentDrinkMedArr = [Disease]()
                                        for med in yourOperationsData{
                                            if let currentDrinkMedDict = med as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(currentDrinkMedDict)
                                                
                                                currentDrinkMedArr.append(disease)
                                            }
                                        }
                                        self.surgeryList = currentDrinkMedArr
                                        self.sortArrays()
                                    }
                                    
                                    if let yourOperationsData = responseDict["your_operations"] as? NSArray{
                                        var currentDrinkMedArr = [Disease]()
                                        for med in yourOperationsData{
                                            if let currentDrinkMedDict = med as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(currentDrinkMedDict)
                                                
                                                currentDrinkMedArr.append(disease)
                                            }
                                        }
                                        self.surgeryList = currentDrinkMedArr
                                        self.sortArrays()
                                    }
                                    
                                    if let familyHrData = responseDict["family_hr_record"] as? NSArray{
                                        var currentDrinkMedArr = [Disease]()
                                        for med in familyHrData{
                                            if let currentDrinkMedDict = med as? [String:Any]{
                                                
                                                let disease = Disease()
                                                disease.updateModelUsingDict(currentDrinkMedDict)
                                                
                                                currentDrinkMedArr.append(disease)
                                            }
                                        }
                                        self.familyHistory = currentDrinkMedArr
                                        self.sortArrays()
                                    }
                                    
                                }
                            } catch let error{
                                print("\(error)")
                            }
                        }
                        
                    }
                    
                } else {
                    print("Failed to get data for ehr")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func getBaseDiseasesUploadData() -> [[String:Any]]{
        var dataArr = [[String:Any]]()
        
        for data in diseasesList{
            let dict = ["checked" : data.checked!,
                        "data" : data.data!,
                        "name" : data.name!] as [String : Any]
            dataArr.append(dict)
        }
        
        return dataArr
    }
    
    func getCurrentDrinkMedicineUploadData() -> [[String:Any]]{
        var dataArr = [[String:Any]]()
        
        for data in currentMedicineList{
            let dict = ["name" : data.name!,
                        "time_data" : data.data!] as [String : Any]
            dataArr.append(dict)
        }
        
        return dataArr
    }
    
    func getFamilyHrRecordUploadData() -> [[String:Any]]{
        var dataArr = [[String:Any]]()
        
        for data in familyHistory{
            let dict = ["checked" : data.checked!,
                        "data" : data.data!,
                        "name" : data.name!] as [String : Any]
            dataArr.append(dict)
        }
        
        return dataArr
    }
    
    func getNormalRecordUploadData() -> [[String:Any]]{
        var dataArr = [[String:Any]]()
        
        for data in lifeStyleList{
            let dict = ["checked" : data.checked!,
                        "name" : data.name!] as [String : Any]
            dataArr.append(dict)
        }
        
        return dataArr
    }
    
    func poisonMedicineRecordUploadData() -> [[String:Any]]{
        var dataArr = [[String:Any]]()
        
        for data in familyHistory{
            let dict = ["time_data" : data.data!,
                        "name" : data.name!] as [String : Any]
            dataArr.append(dict)
        }
        
        return dataArr
    }
    
    func operationUploadData() -> [[String:Any]]{
        var dataArr = [[String:Any]]()
        
        for data in surgeryList{
            let dict = ["checked" : data.checked!,
                        "data" : data.data!,
                        "name" : data.name!] as [String : Any]
            dataArr.append(dict)
        }
        
        return dataArr
    }
}

