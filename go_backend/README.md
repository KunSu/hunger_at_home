# Hunger At Home Backend System

This is the documentation for setting up the backend of the application, the shared folder with design documentation is [here](https://drive.google.com/drive/folders/1322ViiLZdYq3YgdJq1Fxdi8FdqzEirDq)

## Download and Install [Go](https://golang.org/doc/install)
1. Settung up GOPATH for later use.

## Downloading go package and framework 
1. Download [GO gin](https://github.com/gin-gonic/gin#serving-static-files) framework using:
```sh
$ go get -u github.com/gin-gonic/gin
```
2. Download [swaggo](https://github.com/swaggo/gin-swagger) using:
```sh
$ go get -u github.com/swaggo/swag/cmd/swag
```
3. Download [go-sql-driver](https://github.com/go-sql-driver/mysql) using:
```sh
$ go get -u github.com/go-sql-driver/mysql
```

## Install SQL according to the system OS
1. Linux System [LAMPP](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-ubuntu-18-04)
2. Windows [XAMPP](https://www.apachefriends.org/download.html)
3. Create a user: username: "root", password:""

## Have the project cloned and run
1. Create a new folder naming it with your github hostname under GOPATH/src/github.com/, then go under that directory
2. Create a new folder called "hunger_at_home" and go under that directory
3. Download the project and go to "go_backend" folder, copy everything to "hunger_at_home"
4. Go to “swaggo” under “github.com” in the GOPATH, go to “swag/cmd” and find D“swag.exe”
5. Move “swag.exe” to “hunger_at_home”, the same directory where main.go
6. Have terminal open then go under “hunger_at_home”
7. Run “setup.sql” file to setup the database structure following the [guide](https://www.quora.com/How-can-I-run-SQL-file-in-Ubuntu)
8. Init swag and run main.go
```sh
$ ./swag init
$ go run main.go
```
9. Go to [swag webpage](http://localhost:8080/swagger/index.html#/) to test and try different api