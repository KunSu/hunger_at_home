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
	c. Before you run the backend, make sure your port 8080 is not used by other application. CD into go_backend folder, run all .go files using command line: go run main.go loginSystem.go config.go
	d. Done, you can use postman to try few APIs

Backend API Testing
1. Signup Testing
	a. Format: localhost:8080/signup?email={your-emil}&password={your-password}&firstName={firstname}&lastName={lastname}&phoneNumber={phone_number}&userIdentity={identity}
	b. Example: localhost:8080/signup?email=zhadanren1@gmail.com&password=1234&firstName=zha&lastName=danren1&phoneNumber=111&userIdentity=admin
	c. Email has to be unique otherwise it can not be added to the DB, and you will get an error message
2. Login Testing
	a. Format: localhost:8080/login?email={email}&password={password}
	b. Example: localhost:8080/login?email=zhadanren2@gmail.com&password=1234
	c. Only accounts that are already in the DB through Signup can be logged in
	d. If password/email is not correct, you will get an error message
3. Company Signup Testing
	a. Format: localhost:8080/companySignup?companyName={company_name}&address={address}&city={city}&state=C{State}&zipCode={zipcode}&fedID={fedID}&einID={einID}
	b. Example: localhost:8080/companySignup?companyName=c4&address=2713 Der Rey&city=San Jose&state=CA&zipCode=76544&fedID=1asd2&einID=dsa4
	c. Company name is unique at this stage can can be changed later according to the requirements
	d. you can not signup company with the same name for now 
4. Reset Password Testing
	a. Format: localhost:8080/reset?email={email}&password={password}&rePassword={new_password}
	b. Example: localhost:8080/reset?email=zhadanren2@gmail.com&password=12345&rePassword=1234
	c. It can only be applied to the existing accounts, otherwise you will get an error message
	d. More verification methods will be add in to the function later