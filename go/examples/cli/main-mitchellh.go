package main 

import (
	"os"
	"log"
        "github.com/mitchellh/cli"

	clim "github.com/kmova/bootstrap/go/examples/cli/mitchellh"
)

func main() {
	c := cli.NewCLI("app", "1.0.0")
	c.Args = os.Args[1:]
	c.Commands = clim.Commands( nil )

	exitStatus, err := c.Run()
	if err != nil {
		log.Println(err)
	}

	os.Exit(exitStatus)
}
