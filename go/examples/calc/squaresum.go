package calc

import (
	"fmt"
	"os"
	"strconv"
)


func ComplexMath( as, bs string ) int64  {
	a, _ := strconv.ParseInt(as, 10, 64)
	b, _ := strconv.ParseInt(bs, 10, 64)
	return (a*a) + b
}

func main() {
	if len(os.Args) != 3 {
		fmt.Print("Need atleast 2 arguments")
		return
	}
	result := strconv.FormatInt( ComplexMath(os.Args[1], os.Args[2]), 10 )
	fmt.Printf(" %s square + %s is %s\n", os.Args[1], os.Args[2], result )
}
