//
//  RusRefVCViewController.swift
//  Meta
//
//  Created by Max on 17.12.2019.
//  Copyright © 2019 maximgavrilovich. All rights reserved.
//

import UIKit

class RusRefVCViewController: UIViewController {
    
    @IBOutlet weak var refLable: UILabel!
        
        let lableText = """
        Что такое Meta?

        Meta - это мессенджер, разработанный 3-мя людьми в рамках лабораторной работы. Идея проста: обеспечить удобное взаимодействие для людей, независимо от платформы. Я могу удобно взаимодействовать друг с другом.

        Для кого он?
         Наше приложение универсально. Оно может быть использовано детьми, подростками, взрослыми, несмотря на их хобби и профессиональную деятельность, потому что главная задача проекта - быть доступным для всех.
        
        Почему именно Meta?
        
        В отличие от конкурентов, мы предоставляем наши услуги совершенно бесплатно без каких-либо ограничений. Мы будем брать средства к существованию от добровольных пожертвований и рекламы.
        
        Что Вы можете сделать?
        
        Отправлять сообщения
        Добавлять пользователей в друзья
        Создавать свои комнаты
        Изменять тему приложения
        
        Отправка сообщений
        
        1) Выберите комнату во вкладке "Сообщения";
        2) Нажмите на нее;
        3) Введите текст в поле для ввода;
        4) Нажмите на кнопку "Отправить".
    """
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.refLable.text = lableText
        }
        
        @IBAction func backButton(_ sender: Any) {
            let rusRefVC = self.storyboard?.instantiateViewController(identifier: "Settings")
            
            self.view.window?.rootViewController = rusRefVC as? UITabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }
