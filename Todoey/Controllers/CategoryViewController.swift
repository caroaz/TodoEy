
import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    
    var tableCategoryView = UITableView()
    
    var categories = [Categories]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TodoEy"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(CategoryViewController.addButtonTapped))
        addButton.tintColor = .white
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        configureTableView()
        setTableViewDelegates()
//        setsearchConstraint()
       
        //        carga nuestros datos
        loadCategories()
        
    }
    
    
    func configureTableView() {
   
        view.addSubview(tableCategoryView)
        //        setTableViewDelegates()
       tableCategoryView.estimatedRowHeight = 200
        tableCategoryView.rowHeight = UITableView.automaticDimension
        tableCategoryView.register(CellCategory.self, forCellReuseIdentifier: "CategoryCell")
        
        tableCategoryView.pin2(to: view)
        
        
        
    }
//    private  func setsearchConstraint(){
//        //        search.pin(to: view)
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
//
//        ])
//    }
    func setTableViewDelegates(){
        tableCategoryView.dataSource = self
        tableCategoryView.delegate = self
    }
    //    MARK: add new elements
    @objc func addButtonTapped(BtnPsgVar: UIBarButtonItem){

            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Category", style: .default) { [self] (action) in

                //            para guardar datos en coreData primero hay que agregar el context

                let newItem = Categories(context: context)

                newItem.name = textField.text!

                self.categories.append(newItem)

                saveCategories()
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

    func saveCategories (){

        do{
            try context.save()
        }catch{
            print("error saving context")
        }
        self.tableCategoryView.reloadData()
    }
    func loadCategories () {
        let request : NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            //            la salida de este método será una matriz de elementos almacenados en nuestro contenedor
            categories = try  context.fetch(request)
        }catch {
            print("error al recuperar datos de context \(error)")
        }
        tableCategoryView.reloadData()

    }

}

//MARK: - EXTENSIONS
extension CategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableCategoryView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CellCategory
        
        cell.prepare()
        
        let results = categories[indexPath.row]
        cell.set(tasks: results.name ?? "")
        
       
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
//        return 1
    }
    
}
extension CategoryViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vcTodoList = TodoLitsViewController()
        vcTodoList.selectedCategory = categories[indexPath.row]
               
               
               navigationController?.pushViewController(vcTodoList, animated: true)

}
}
//MARK: Search bar methods
//extension TodoLitsViewController: UISearchBarDelegate {
//    //    esto dice al delegado que el botón de búsqueda ha sido tocado
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //        read the context
//        let request : NSFetchRequest<Items> = Items.fetchRequest()
//        //        consultar datos a coreData con Predicate (como queremos buscar nuestros resultados
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //        clasificar los datos obtenidos
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//
//        print(searchBar.text!)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}


