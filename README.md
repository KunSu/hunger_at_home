# Huger At Home Project

#### Website: https://hungerathome.org/

Setup Backend
1. Download Go and install on local machine : https://golang.org/doc/install
	a. Go workspace and PATH are also needed to run .go
		Mac: https://sourabhbajaj.com/mac-setup/Go/
		Linux: https://www.linode.com/docs/development/go/install-go-on-ubuntu/
2. Install dependancies
	a. Go Gin: go get -u github.com/gin-gonic/gin
	b. Go SQL driver: go get -u github.com/go-sql-driver/mysql
3. Start Backend
	a. Have local DB running, the default db info is listed below (stated in config.go)
		const (
			host     = "localhost"
			port     = "3306"
			user     = "root"
			password = ""
			dbName   = "foodapp"
		)
		user can change related info according to their own db setting
	b. Copy paste the code from Setup.sql or run it in local db application to create local database
	c. Before you run the backend, make sure your port 8080 is not used by other application. CD into go_backend folder, run all .go files using command line: 
	```
	go run config.go checkingTools.go companyInfo.go orderRecords.go userInfo.go main.go
	```
	d. Done, you can use postman to try few APIs

Backend API Testing(Assuming the default port as 8080)
1. userInfo.go
	Description: a go file that stores user related APIs such as signup and login
	Detailed API
		Signup:
			a. URL: localhost:8080/api/signup (POST request)
			b. Body Content:{"email": "zhadanren1@gmail.com", "password": "1234", "firstName": "zhadan", "lastName": "ren", "phoneNumber": "4445556666", "userIdentity": "admin", "companyID": "12", "secureQuestion": "something", "secureAnswer": "something"}
		Login:
			a. URL: localhostL:8080/api/login (GET request)
			b. Parameter content: localhost:8080/login?email=zhadanren1@gmail.com&password=1234
			c. MD5 havent been applied yet but it can be done very soon

