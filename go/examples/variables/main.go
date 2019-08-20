package main

import  (
	"fmt"
)

const CONSTVAR = 1
var GlobalVar = 1

func main() {
	name, age := "Dobby", 100
        fmt.Println(GlobalVar)
        fmt.Println(name, age)
	//CONSTVAR++
	//Not allowed
	GlobalVar++
        fmt.Println(GlobalVar)
}
