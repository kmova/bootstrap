package main

import  (
	"fmt"
)

type Person struct {
	name	string
	email	string
}

func (p Person) Print() {
        fmt.Println( p.name, p.email )
}

func (p Person) ChangeEmail(newEmail string) {
        p.email = newEmail
}

type Asian struct {
	Person
	country string
}

func (a Asian) Print() {
	a.Person.Print()
        fmt.Println( a.country )
}

func main() {
	var p = Asian{
		Person: Person{
			name: "jane",
			email: "jane@austin.com",
		},
		country: "india",
	}

	p.Print()

	//p.ChangeEmail( "jane@jane.com" )
	//p.Print()

}
