

import UIKit
import CoreData

class TodoLitsViewController: UIViewController {
    
    
    var tableView = UITableView()
    var searchBar = UISearchBar()
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    
    var tasks = [Items]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TodoEy"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(TodoLitsViewController.addButtonTapped))
        addButton.tintColor = .white
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        configureTableView()
        setTableViewDelegates()
        setsearchConstraint()
        searchBar.delegate = self
        //        carga nuestros datos
        loadItems()
        
    }
    
    
    func configureTableView() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        //        setTableViewDelegates()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CellList.self, forCellReuseIdentifier: "ListCell")
        
        tableView.pin(to :view)
        
    }
    private  func setsearchConstraint(){
        //        search.pin(to: view)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            
        ])
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
            
            //            para guardar datos en coreData primero hay que agregar el context
            
            let newItem = Items(context: context)
            
            newItem.title = textField.text!
            newItem.done = false
//            relationShip
            newItem.parentCategory = self.selectedCategory
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
    
    //    MARK: - Model Manipulation
    
    func saveItems (){
        
        do{
            try context.save()
        }catch{
            print("error saving context")
        }
        self.tableView.reloadData()
    }
    func loadItems (with request: NSFetchRequest<Items> =  Items.fetchRequest(), predicate : NSPredicate? = nil) {
        
        
        let categoryPredicate =  NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
      
        do {
            //            la salida de este método será una matriz de elementos almacenados en nuestro contenedor
            tasks = try  context.fetch(request)
        }catch {
            print("error al recuperar datos de context \(error)")
        }
        tableView.reloadData()
        
    }
    
}

//MARK: - EXTENSIONS
extension TodoLitsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! CellList
        
        cell.prepare()
        
        let results = tasks[indexPath.row]
        cell.set(tasks: results.title ?? "")
        
        cell.accessoryType = results.done == true ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
}
extension TodoLitsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellContent = tasks[indexPath.row]
        //        context.delete(cellContent)
        //        tasks.remove(at: indexPath.row)
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        print(cellContent)
    }
}
//MARK: Search bar methods
extension TodoLitsViewController: UISearchBarDelegate {
    //    esto dice al delegado que el botón de búsqueda ha sido tocado
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        read the context
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        //        consultar datos a coreData con Predicate (como queremos buscar nuestros resultados
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //        clasificar los datos obtenidos
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate : predicate)
        
        print(searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
