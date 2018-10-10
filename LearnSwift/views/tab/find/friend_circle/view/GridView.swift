//
//  GridView.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/5.
//  Copyright © 2018年 张琳. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    /// 图片数组
    var urls:[String] = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534099707133&di=47302e16011f3400e3d54a74b18196c6&imgtype=0&src=http%3A%2F%2Fmg.soupingguo.com%2Fattchment2%2FXinWen%2F0x0%2F2015%2F01%2F30%2F20%2F8b09ee9d-0c14-474b-9ca0-52d53cdc254c.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534099707133&di=47302e16011f3400e3d54a74b18196c6&imgtype=0&src=http%3A%2F%2Fmg.soupingguo.com%2Fattchment2%2FXinWen%2F0x0%2F2015%2F01%2F30%2F20%2F8b09ee9d-0c14-474b-9ca0-52d53cdc254c.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534099707133&di=47302e16011f3400e3d54a74b18196c6&imgtype=0&src=http%3A%2F%2Fmg.soupingguo.com%2Fattchment2%2FXinWen%2F0x0%2F2015%2F01%2F30%2F20%2F8b09ee9d-0c14-474b-9ca0-52d53cdc254c.jpg"] {
        didSet{
            setUI()
        }
    }
    
    /// 一行几列
    var column:Int = 3 {
        didSet{
            setUI()
        }
    }
    
    /// 图片之间的间距
    var space:CGFloat = 5 {
        didSet{
            setUI()
        }
    }
    
    
    
    init(urls:[String]) {
        super.init(frame: CGRect.zero)
        self.urls = urls
        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    
    private func setUI(){
        
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
       
        if urls.count == 1 {
            
            let view:UIImageView = UIImageView()
            view.backgroundColor = UIColor.black
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFill
            view.layer.masksToBounds = true
            self.addSubview(view)
            
     
            //self.downLoad(url: urls[0], view: view)
            
            
            NetWork.downloadImageToImageDictionary(url: urls[0], success: { (image, data) in
                view.image = image
            }, failed: nil)
           
            
            let top = view.topAnchor.constraint(equalTo: self.topAnchor)
            let left = view.leftAnchor.constraint(equalTo: self.leftAnchor)
            let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            let right = view.rightAnchor.constraint(equalTo: self.rightAnchor)
            let height = view.heightAnchor.constraint(equalTo: view.widthAnchor)
            
            NSLayoutConstraint.activate([top,left,bottom,right,height])
            return
            
        }else if urls.count < column {
            for _ in 0 ..< column - urls.count {
                urls.append("")
            }
        }else if urls.count == 4 {
            urls.insert("", at: 2)
        }
    
        for(index,value) in urls.enumerated() {
            
            let view:UIImageView = UIImageView()
            view.backgroundColor = UIColor.red
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isHidden = value == "" ? true : false
            view.contentMode = .scaleAspectFill
            view.layer.masksToBounds = true
            self.addSubview(view)
            
            view.setNetWrokUrl(imageUrl: value)
            
            
//            NetWork.downloadImageToImageDictionary(url: value, success: { (image, data) in
//                view.image = image
//            }, failed: nil)
//
        
            var left:NSLayoutConstraint!,top:NSLayoutConstraint!
            
            
            if index == 0 {
                left = view.leftAnchor.constraint(equalTo: self.leftAnchor)
                top = view.topAnchor.constraint(equalTo: self.topAnchor)
            }else{
                
                if index % column == 0 {
                    top = view.topAnchor.constraint(equalTo: self.subviews[index - 1].bottomAnchor, constant:space)
                    left = view.leftAnchor.constraint(equalTo: self.leftAnchor)
                }else{
                    top = view.topAnchor.constraint(equalTo: self.subviews[index - 1].topAnchor)
                    left = view.leftAnchor.constraint(equalTo: self.subviews[index - 1].rightAnchor, constant:space)
                }
                
                if index % column == (column - 1) {
                    let right:NSLayoutConstraint = view.rightAnchor.constraint(equalTo: self.rightAnchor)
                    NSLayoutConstraint.activate([right])
                }
                let width = view.widthAnchor.constraint(equalTo: self.subviews[index - 1].widthAnchor)
                NSLayoutConstraint.activate([width])
            }
            
            if index == urls.count - 1 {
                let bottom:NSLayoutConstraint = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                NSLayoutConstraint.activate([bottom])
            }
  
            let height:NSLayoutConstraint = view.heightAnchor.constraint(equalTo: view.widthAnchor)
            
            NSLayoutConstraint.activate([top,left,height])

        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for v in self.subviews {
            print("v == \(v.frame)")
        }
    }
    
    
    
    func downLoad(url:String,view:UIImageView){
        

        if url.hasPrefix("http://") && (url.hasSuffix(".png")||url.hasSuffix(".jpg")) == false {
            print("图片url格式错误")
            return
        }
        
        let array = url.split(separator: "/")
        let imageName = String(array.last!)
        
        if let data = FileOption.readFile(path: NSTemporaryDirectory() + "Image/\(imageName)") {
            view.image = UIImage(data: data as Data)
            return
        }
    
        URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            
            DispatchQueue.main.async() { () -> Void in
                
                view.image = UIImage(data: data)
                
            }

            let bool:Bool = FileOption.writeFile(documentName: NSTemporaryDirectory() + "Image", fileName: imageName, data: data as NSData)
            
            

            }.resume()
        

        
    }

}






