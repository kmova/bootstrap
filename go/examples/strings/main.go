package main

import "fmt"
import "strings"

func main() {

	fmt.Printf(excludeI("5G"))
	fmt.Printf(excludeI("5Gi"))
	fmt.Printf(excludeI("5GiB"))
}

func excludeI(size string) string {
	return strings.Split(size, "i")[0]
}
