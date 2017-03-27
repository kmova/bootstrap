package mitchellh

import (
        "fmt"
)

// BookCommand is a Command implementation for storing book information
type BookCommand struct {
        Name            string
        ReadTime        int
        Entry           bool
}

func (c *BookCommand) Help() string {
        return ""
}

func (c *BookCommand) Run(_ []string) int {

        fmt.Println("Name: ", c.Name)
        fmt.Println("Reading Time in minutes: ", c.ReadTime)
        fmt.Println("Entry Level?: ", c.Entry)

        return 0
}

func (c *BookCommand) Synopsis() string {
        return "Add new book details"
}
