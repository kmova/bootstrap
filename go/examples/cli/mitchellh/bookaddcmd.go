package mitchellh

import (
        "fmt"
        "flag"
        "strings"
)

// BookAddCommand is a Command implementation for storing book information
type BookAddCommand struct {
        Name            string
        ReadTime        int
        Entry           bool
}

func (c *BookAddCommand) Help() string {
        helpText := `
Usage: app book add [--<optional parameters>=value]

  Add a new book or article information 

Options:

  --book-name=<Name of the book or article>
  --book-title=<Name of the book or article>

  --read-time=<Int Value>
    Approximate minutes for reading the book

  --entry-level=<true|false>
    Is this a beginner book or article?
`
        return strings.TrimSpace(helpText)
}

func (c *BookAddCommand) Run(args []string) int {

        flags := flag.NewFlagSet("book add", flag.ContinueOnError)
        flags.Usage = func() { fmt.Println(c.Help()) }

        const (
                nameDefault = "Introduction to Go Programming"
                nameDescr   = "Name of the Book or Article "

                readTimeDefault  = 60
                readTimeDescr   = "How much time (in minutes) do you require to read?"

                entryDefault = false
                entryDescr   = "Is this an entry level book?"

        )

        flags.StringVar(&c.Name, "book-name", nameDefault, nameDescr)
        flags.StringVar(&c.Name, "book-title", nameDefault, nameDescr)

        flags.IntVar(&c.ReadTime, "read-time", readTimeDefault, readTimeDescr)

        flags.BoolVar(&c.Entry, "entry-level", entryDefault, entryDescr)



        if err := flags.Parse(args); err != nil {
		fmt.Println(c.Help())
                return 1
        }

        // There are no extra arguments
        oargs := flags.Args()
        if len(oargs) != 0 {
		fmt.Println(c.Help())
                return 1
        }

        fmt.Println("Name: ", c.Name)
        fmt.Println("Reading Time in minutes: ", c.ReadTime)
        fmt.Println("Entry Level?: ", c.Entry)

        return 0
}

func (c *BookAddCommand) Synopsis() string {
        return "Add new book details"
}
