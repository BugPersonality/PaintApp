//
//  MenuViewController .swift
//  DrawingApp
//
//  Created by Данил Дубов on 01.04.2021.
//

import UIKit

class MenuViewController: UIViewController {
    
    let tableViewOfCanvases = UITableView()
    
    var canvases: [CanvasCellStruct] = []
    
    struct CanvasCellIdentifier {
        static let identifier = "CanvasCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVCHead()
        configurateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewOfCanvases.reloadData()
        setupVCHead()
    }
    
    func configurateTableView() {
        view.addSubview(tableViewOfCanvases)
        setupTableViewDelegate()
        tableViewOfCanvases.rowHeight = 100
        tableViewOfCanvases.register(CanvasCell.self, forCellReuseIdentifier: CanvasCellIdentifier.identifier)
        setupTableViewLayout()
        
        tableViewOfCanvases.showsVerticalScrollIndicator = false
        tableViewOfCanvases.separatorStyle = .none
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureForCell))
        tableViewOfCanvases.addGestureRecognizer(longPress)
    }
    
    func setupTableViewDelegate() {
        tableViewOfCanvases.delegate = self
        tableViewOfCanvases.dataSource = self
    }
    
    func setupVCHead() {
        title = "Your's Canvases"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddCanvasButton))
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    @objc fileprivate func handleAddCanvasButton() {
        let alert = UIAlertController(title: "Add new canvas", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
       
        let addNewCanvas = UIAlertAction(title: "Add", style: .default) { [unowned alert] _ in
            let name = alert.textFields![0].text
            self.canvases.append(CanvasCellStruct(canvas: Canvas(), title: name ?? "None"))
            self.tableViewOfCanvases.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(addNewCanvas)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canvases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOfCanvases.dequeueReusableCell(withIdentifier: CanvasCellIdentifier.identifier) as! CanvasCell
        cell.putDataIntoCell(canvas: canvases[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newView = CanvasViewController()
        newView.putCanvas(canvas: canvases[indexPath.row].canvas)
        navigationController?.pushViewController(newView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            canvases.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc fileprivate func handleLongPressGestureForCell(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableViewOfCanvases)
            if let indexPath = tableViewOfCanvases.indexPathForRow(at: touchPoint) {
                let alert = UIAlertController(title: "Rename canvas", message: nil, preferredStyle: .alert)

                alert.addTextField()

                let addNewCanvas = UIAlertAction(title: "Rename", style: .default) { [unowned alert] _ in
                    let name = alert.textFields![0].text
                    self.canvases[indexPath.row].title = name!
                    self.tableViewOfCanvases.reloadData()
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

                alert.addAction(addNewCanvas)
                alert.addAction(cancelAction)

                present(alert, animated: true)
            }
        }
    }
}

extension MenuViewController {
    fileprivate func setupTableViewLayout() {
        tableViewOfCanvases.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewOfCanvases.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewOfCanvases.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableViewOfCanvases.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewOfCanvases.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

