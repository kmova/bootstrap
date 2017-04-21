package main

import "fmt"
import greet "github.com/kmova/bootstrap/go/examples/hello/greetings"

func main() {
	fmt.Printf( hello() )
	fmt.Printf( greet.SelfIntro() )
}

func hello() string {
	return "Hello world!"
}

