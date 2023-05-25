package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
)

func main() {

	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.String(200, "Hello World, I'm a Gin server v2 with auto push.")
	})
	fmt.Println("v2 push.")

	r.Run(":8080")
}
