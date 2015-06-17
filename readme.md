# ![](https://github.com/DmitrJuga/MyToDoList/blob/master/MyToDoList/Images.xcassets/AppIcon.appiconset/mzl.hrtieshw-29@2x.png)  Напоминалки / MyToDoList

**"Напоминалки"** - простой список задач (to-do list) с напоминаниями. Учебный (тренировочный) проект на **Objective-C** c использованием **локальных нотификаций**.

![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot1.png)
![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot2.png)

## Функционал

- Добавление/просмотр/редактирование/удаление напоминаний.
- Каждое напоминание содержит краткое описание события или дела, его важность (визуальный признак), дополнительные заметки, дату и время напоминания.
- Список напоминаний отсортирован по дате и времени, отображает текст напоминания, визуальный признак важности, дату и время.
- При наступлении времени напоминания пользователь получает уведомление - через *Центр уведомлений* (если приложение не активно) или непосредственно в приложении.
- При получении уведомления можно открыть соответствующее напомнинание для просмортра деталей, при необходимости - отредактировать его (например, задать новые дату и время) и сохранить повторно.
- *При первом запуске запрашивается разрешение на отправку приложением уведомлений.*

## Technical Details

**UIKit framework usage:**
- `UILocalNotifications`: creating/scheduling/canceling/**handling**;
- `AppDelegate` methods `application:didFinishLaunchingWithOptions:` and `application:didReceiveLocalNotification:` with custom code for handling **notifications**.
- `UIViewController` + `UITableView` with custom cells for event list.
- `UITableViewController` with static cells for event details.
- `UITextField`, `UITextView`, `UIDatePicker`, `UISegmentedControl`, `UIButton`, `UIAlertController`.
- Auto Layout (Storyboard constraints).

**Extra:**
- App Icon (image from free web source).

## More Screenshots

![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot3.png)
![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot3a.png)   
![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot4.png)
![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot4a.png)   
![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot5.png)
![](https://github.com/DmitrJuga/MyToDoList/blob/master/screenshots/screenshot6.png)   

## Основа проекта

Проект создан на основе моей домашней работы к уроку 8 по курсу **"Objective C. Уровень 1"** в НОЧУ ДО «Школа программирования» ([http://geekbrains.ru](http://geekbrains.ru/users/38648)) и доработан после окончания курса **"Objective C. Уровень 2"**. Домашнее задание и пояснения к выполненой работе - см. в [homework_readme.md](https://github.com/DmitrJuga/MyToDoList/blob/master/homework_readme.md).

---

### Contacts

**Дмитрий Долотенко / Dmitry Dolotenko**

Krasnodar, Russia   
Phone: +7 (918) 464-02-63   
E-mail: <dmitrjuga@gmail.com>   
Skype: d2imas

:]

