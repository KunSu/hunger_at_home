package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func main() {
	fmt.Println("Hello World")

	r := gin.Default()
	r.GET("/", homePage)
	r.GET("/signup", querySignUp)
	r.GET("/login", queryLogin)
	r.GET("/reset", queryResetPassword)
	r.GET("/companySignup", queryCompanySignUp)
	r.Run()
}
