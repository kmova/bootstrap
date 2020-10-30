package main

import  (
	"fmt"
)


func main() {
	i := 0
	for i < 7 {
		match := ""
		switch i {
		case 0:
		case 1:
		case 3:
			match = "odd"
		case 2:
		case 4:
			match = "even"
		default:
			match = "default"
		}
        	fmt.Println( i , "is" , match)
		i = i + 1
	}
}
