

import UIKit

class ViewController: UIViewController {
    
    
    var tableView = UITableView()
    var tasks = [Items]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TodoEy"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(ViewController.addButtonTapped))
        addButton.tintColor = .white
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        configureTableView()
        setTableViewDelegates()
        
        //        carga nuestros datos
        loadItems()
        
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        //        setTableViewDelegates()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CellList.self, forCellReuseIdentifier: "ListCell")
        
        tableView.pin(to :view)
        
    }
    func setTableViewDelegates(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    //    MARK: add new elements
    @objc func addButtonTapped(BtnPsgVar: UIBarButtonItem){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            
            let newItem = Items()
            newItem.title = textField.text!
            self.tasks.append(newItem)
            
            saveItems()
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "create New Item"
            textField = alertTextField
            print(alertTextField.text!)
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems (){
        
        //        guardamos los datos en un plist
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.tasks)
            try data.write(to : dataFilePath!)
        }catch{
            print("Error")
        }
        tableView.reloadData()
    }
    func loadItems () {
        
        //        los datos son igual a los datos guardados en esa url
        if let data = try? Data(contentsOf: dataFilePath!){
            //            decofica los datos guardados en plist y devuelve los datos en un array de items [Items]
            let decoder = PropertyListDecoder()
            do {
                tasks = try decoder.decode([Items].self, from: data)
            }catch {
                print("error")
            }
        }
    }
    
}

//MARK: - EXTENSIONS
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! CellList
        
        cell.prepare()
        
        let results = tasks[indexPath.row]
        cell.set(tasks: results.title)
        
        cell.accessoryType = results.done == true ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
}
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellContent = tasks[indexPath.row]
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        print(cellContent)
    }
}

