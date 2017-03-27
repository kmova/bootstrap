// Example showing the usage of mitchellh/cli to implement a Book CLI 
//
// This example can be used to input information about 
// a Golang Book or Article.
package mitchellh

import (
        "github.com/mitchellh/cli"
)

// Commands returns the mapping of Book CLI commands. The meta
// parameter lets you set meta options for all commands.
func Commands() map[string]cli.CommandFactory {

        return map[string]cli.CommandFactory{
                "book": func() (cli.Command, error) {
                        return &BookCommand{
                        }, nil
                },
        }
}

