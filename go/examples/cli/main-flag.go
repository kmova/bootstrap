package main 

import (
	"flag"
	"fmt"

	cliflag "github.com/kmova/bootstrap/go/examples/cli/flag"
)

func main() {
	flag.Parse()

	if ( 1 > flag.NFlag() ) {
		fmt.Println("Valid arguments are:")
		flag.PrintDefaults()
	} else {
		fmt.Println("Name:", cliflag.CliBook.Name)
		fmt.Println("Reading Time in minutes:", cliflag.CliBook.ReadTime)
		fmt.Println("Entry Level?:", cliflag.CliBook.Entry)
	}
}
