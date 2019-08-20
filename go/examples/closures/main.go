package main

import  (
	"fmt"
)

var n = 5

func PrintTableValue(f func(x int)(int) ) {
	v := f(n)
        fmt.Println(v)

}


func main() {
	for i := 1; i < 5; i++ {
        	fn := func(x int) (int) {
			return x * i
		}
		PrintTableValue(fn)
	}

}
