package main

import (
	"github.com/gin-gonic/gin"
)

func main() {

	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.String(200, "Hello World, I'm a Gin server v2 with auto push.")
	})

	r.Run(":8080")
}
