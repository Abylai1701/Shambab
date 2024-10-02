import UIKit
import Combine
import SnapKit

final class MainVC: UIViewController {
    
    private var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var mainTitle : UILabel = {
        let label = UILabel()
        label.text = "Клеточное наполнение"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .robotoMedium(ofSize: 20)
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 49/255, green: 0/255, blue: 80/255, alpha: 1).cgColor,
            UIColor.black.cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.frame = view.bounds
        return layer
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MainCell.self,
                       forCellReuseIdentifier: MainCell.cellId)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var createButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(red: 90/255, green: 52/255, blue: 114/255, alpha: 1)
        configuration.cornerStyle = .medium
        configuration.title = "СОТВОРИТЬ"
        configuration.buttonSize = .medium
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.titleLabel?.font = .robotoMedium(ofSize: 14)
        button.addTarget(self,
                         action: #selector(goToCreate),
                         for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            try await CoreDataManager.shared.clearAllData()
        }
        bind()
        setupViews()
    }
    
    func bind() {
        viewModel.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                print("Таблица обновленаф")
            }
            .store(in: &cancellables)
    }
    private func setupViews() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubviews(mainTitle,
                         createButton,
                         tableView)
        
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-76)
        }
    }
    @objc private func goToCreate() {
        let randomState = Bool.random()
        viewModel.addNewCell(state: randomState)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

            guard self.viewModel.cells.count > 0 else { return }

            self.tableView.scrollToRow(at: IndexPath(row: 0, section: self.viewModel.cells.count - 1), at: .bottom, animated: true)
            }
    }
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.cellId, for: indexPath) as! MainCell
        cell.configure(state: viewModel.cells[indexPath.section])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
