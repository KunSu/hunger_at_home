package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func main() {
	fmt.Println("Hello World")

	r := gin.Default()
	//TODO: URL design and catagorize them into different /
	r.GET("/", homePage)
	r.POST("api/signup", querySignUp)
	// r.GET("api/login", queryLogin)
	// r.GET("api/reset", queryResetPassword)
	// r.POST("api/companySignup", queryCompanySignUp)
	// r.POST("api/addressCompanyAssociate", queryCompanyAddressAssociate)
	// r.POST("api/donation", queryDonation)
	// r.POST("api/request", queryRequest)
	r.Run()
}
