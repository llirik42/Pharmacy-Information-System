# Реализация приложения базы данных в архитектуре клиент-сервер

## Реализация
* [Клиентская часть](https://github.com/llirik42/Pharmacy-Information-System-Frontend)
* [Серверная часть](https://github.com/llirik42/Pharmacy-Information-System-Backend)

## Задание

Для выбранного проекта разработать структуру базы данных и реализовать приложение в архитектуре клиент-сервер, выполняющее операции внесения данных в базу данных, редактирование данных и запросы, указанные в проекте. Клиентская часть реализуется на языке программирования высокого уровня. В описании проекта дана обобщенная пользовательская спецификация приложения. Спецификация не предполагает оптимального определения структур данных, но задает полный перечень хранимой в базе данных информации и выполняемых программой функций. Таблицы должны заполняться адекватными значениями, примерно по 7 объектов в каждой.

### Этапы

1. Разработка структуры базы данных (серверная часть)
	1. Проектирование инфологической модели задачи. Определение сущностей, атрибутов сущностей, идентифицирующих атрибутов, связей между сущностями. При проектировании должны учитываться требования гибкости структур для выполнения перечисленных функций и не избыточного хранения данных.
	2. Проектирование схемы базы данных: описание схем таблиц, типов (доменов) атрибутов, определение ограничений целостности. Написание SQL скриптов по созданию таблиц БД.
	3. Создание и заполнение разработанной БД на стороне сервера.
2. Написание SQL запросов к спроектированной базе данных согласно заданию.
3. Реализация триггеров и хранимых процедур (PL/SQL).
4. Разработка приложения клиента (формы ввода, редактирования и поиска данных по запросам).
