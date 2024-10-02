import UIKit
import SnapKit

class MainCell: UITableViewCell {
    
    //MARK: - Properties
    private lazy var imageOne: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    private lazy var imageTwo: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        return image
    }()
    private lazy var labelOne: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium(ofSize: 20)
        label.textColor = .black
        return label
    }()
    private lazy var labelTwo: UILabel = {
        let label = UILabel()
        label.font = .robotoRegular(ofSize: 14)
        label.textColor = .black
        return label
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    //MARK: - Setup Views
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 8
        selectionStyle = .none
        addSubviews(imageOne,
                    imageTwo,
                    labelOne
        )
        labelOne.addSubview(labelTwo)
        imageOne.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(16)
            make.size.equalTo(40)
        }
        imageTwo.snp.makeConstraints { make in
            make.center.equalTo(imageOne.snp.center)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        labelOne.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(imageOne.snp.right).offset(16)
        }
        labelTwo.snp.makeConstraints { make in
            make.top.equalTo(labelOne.snp.bottom).offset(2)
            make.left.equalTo(imageOne.snp.right).offset(16)
        }
    }
    
    func configure(state: MyNewEntity) {
        switch state.cellState {
        case 0:
            imageOne.image = .liveBig
            imageTwo.image = .liveSmall
            
            labelOne.text = "Живая"
            labelTwo.text = "и шевелится!"
        case 1:
            imageOne.image = .deadBig
            imageTwo.image = .deadSmall
            
            labelOne.text = "Мертвая"
            labelTwo.text = "или прикидывается"
        case 3:
            imageOne.image = .deathBig
            imageTwo.image = .death
            
            labelOne.text = "Смерть"
            labelTwo.text = "даже не шевелится"
        case 2:
            imageOne.image = .lifeBig
            imageTwo.image = .lifeSmall
            
            labelOne.text = "Жизнь"
            labelTwo.text = "Ку-ку!"
        default:
            break
        }
    }
}
