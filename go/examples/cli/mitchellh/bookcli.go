// Example showing the usage of mitchellh/cli to implement a Book CLI
//
// This example can be used to input information about
// a Golang Book or Article.
package mitchellh

import (
	"github.com/mitchellh/cli"
)

// Commands returns the mapping of Book CLI commands.
// Specifying a space in the key, will add the command as sub-command
func Commands() map[string]cli.CommandFactory {

	return map[string]cli.CommandFactory{
		"book add": func() (cli.Command, error) {
			return &BookAddCommand{}, nil
		},
		"book list": func() (cli.Command, error) {
			return &BookListCommand{}, nil
		},
	}
}
