package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/mitchellh/cli"

	cliflag "github.com/kmova/bootstrap/go/examples/cli/flag"
	clim "github.com/kmova/bootstrap/go/examples/cli/mitchellh"
)

func main() {
	fmt.Println("Select CLI option from below:")
	fmt.Println("1. flags")
	fmt.Println("2. mitchellh/cli")

	var i int
	_, err := fmt.Scanf("%d", &i)

	if nil != err {
		fmt.Println("Unable to process input")
		os.Exit(1)
	}

	switch i {
	case 1:
		createFlagsCLI()
	case 2:
		createMitchellCLI()
	default:
		fmt.Println("Invalid CLI Option selected")
	}

}

func createMitchellCLI() {
	c := cli.NewCLI("app", "1.0.0")
	c.Args = os.Args[1:]
	c.Commands = clim.Commands()

	exitStatus, err := c.Run()
	if err != nil {
		log.Println(err)
	}

	os.Exit(exitStatus)
}

func createFlagsCLI() {
	flag.Parse()

	if 1 > flag.NFlag() {
		fmt.Println("Valid arguments are:")
		flag.PrintDefaults()
	} else {
		fmt.Println("Name:", cliflag.CliBook.Name)
		fmt.Println("Reading Time in minutes:", cliflag.CliBook.ReadTime)
		fmt.Println("Entry Level?:", cliflag.CliBook.Entry)
	}
}
