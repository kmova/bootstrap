package mitchellh

import (
        "bytes"
        "fmt"

        "github.com/mitchellh/cli"
)

// BookCommand is a Command implementation for storing book information
type BookCommand struct {
        Name            string
        ReadTime        int
        Entry           bool
        Ui              cli.Ui
}

func (c *BookCommand) Help() string {
        return ""
}

func (c *BookCommand) Run(_ []string) int {
        var outString bytes.Buffer

        fmt.Fprintf(&outString, "Name: %s", c.Name)
        fmt.Fprintf(&outString, "Reading Time in minutes: %s", c.ReadTime)
        fmt.Fprintf(&outString, "Entry Level?: %s", c.Entry)

        c.Ui.Output(outString.String())
        return 0
}

func (c *BookCommand) Synopsis() string {
        return "Add new book details"
}
