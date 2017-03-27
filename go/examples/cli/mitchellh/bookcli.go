// Example showing the usage of mitchellh/cli to implement a Book CLI 
//
// This example can be used to input information about 
// a Golang Book or Article.
package mitchellh

import (
        "os"

        "github.com/mitchellh/cli"
)

// Commands returns the mapping of Book CLI commands. The meta
// parameter lets you set meta options for all commands.
func Commands(metaPtr *command.Meta) map[string]cli.CommandFactory {
        if metaPtr == nil {
                metaPtr = new(command.Meta)
        }

        meta := *metaPtr
        if meta.Ui == nil {
                meta.Ui = &cli.BasicUi{
                        Reader:      os.Stdin,
                        Writer:      os.Stdout,
                        ErrorWriter: os.Stderr,
                }
        }

        return map[string]cli.CommandFactory{
                "book": func() (cli.Command, error) {
                        return &BookCommand{
                                M: meta,
                        }, nil
                },
        }
}

