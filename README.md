# Examination-Database-System
* This project is a database system for managing examination data using Microsoft SQL Server. 
* It allows users to create, update, delete, and query exam records, as well as generate reports and statistics.
* The project demonstrates the use of SQL queries, stored procedures, triggers, views, and functions.
* It also includes a graphical user interface (GUI) for interacting with the database.

### Features
* CRUD operations on exam records
* Data validation and error handling
* Report generation and data visualization
* User authentication and authorization
* Backup and restore database
* Installation: To run this project, you need to have the following software installed on your machine:

* Microsoft SQL Server 2019 or later.
* Microsoft SQL Server Management Studio (SSMS) 18 or later.
* Visual Studio 2019 or later with .NET Framework 4.8 or later.
* You also need to clone this repository to your local machine using the following command:

* git clone https://github.com/your_username/examination-database-system.git

### Usage
* To use this project, follow these steps:

* Open SSMS and connect to your SQL Server instance.
* Create a new database named ExaminationDB and execute the script Database.sql located in the SQL folder of the repository. This will create all the tables, procedures, triggers, views, and functions needed for the project.
* Open Visual Studio and open the solution file ExaminationDB.sln located in the GUI folder of the repository.
* In the Solution Explorer, right-click on the ExaminationDB project and select Properties.
* In the Settings tab, change the value of the ConnectionString setting to match your SQL Server connection string. For example:
* Data Source=localhost;Initial Catalog=ExaminationDB;Integrated Security=True

* Save the changes and build the solution.
* Run the project by pressing F5 or clicking on the Start button.
* Log in with the default credentials: username: admin, password: admin.
* Explore the features of the project.

This project is open for contributions. If you want to contribute to this project, please follow these steps:

* Fork this repository to your GitHub account.
* Create a new branch with a descriptive name for your feature or bug fix.
* Make your changes in the branch and commit them with a clear message.
* Push your branch to your forked repository.
* Create a pull request from your branch to the master branch of this repository.
Wait for feedback or approval.
