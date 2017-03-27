package mitchellh

import (
        "fmt"
)

// BookListCommand is a Command implementation for storing book information
type BookListCommand struct {
        Name            string
        ReadTime        int
        Entry           bool
}

func (c *BookListCommand) Help() string {
        return ""
}

func (c *BookListCommand) Run(_ []string) int {

        fmt.Println("TBD : Will list the books added")

        return 0
}

func (c *BookListCommand) Synopsis() string {
        return "List the book details"
}
