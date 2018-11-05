package main

import "github.com/jpillora/go-ogle-analytics"

func fireEvent( cid, ds, ec, ea, el string, ev int64 ) {
	client, err := ga.NewClient("UA-127388617-1")
	if err != nil {
		panic(err)
	}

	//client.ClientID("20eacc6c-e109-11e8-9f32-f2801f1b9fd1")
	client.ClientID( cid )

	client.DataSource( ds )
	client.ApplicationInstallerID("K8s-1.10")
	client.ApplicationID("OpenEBS")
	client.ApplicationName("OpenEBS")
	client.ApplicationVersion("0.8.0")

	event := ga.NewEvent(ec, ea)
	event.Label( el )
	event.Value( ev )

	err = client.Send(event)
	//err = client.Send(ga.NewEvent("Foo", "Bar").Label("Bazz"))
	if err != nil {
		panic(err)
	}
	println("Event fired!")
}

func main() {
	//fireEvent( "20eacc6c-e109-11e8-9f32-f2801f1b9fd1", "Minikube", "Install", "Success", "Size", 1 )
	//fireEvent( "20eacc6c-e109-11e8-9f32-f2801f1b9fd2", "GKE", "Install", "Success", "Size", 2 )
	//fireEvent( "20eacc6c-e109-11e8-9f32-f2801f1b9fd3", "AWS", "Install", "Success", "Size", 3 )

	fireEvent( "20eacc6c-e109-11e8-9f32-f2801f1b9fd3", "AWS", "Volume Jiva Create", "Success", "Size", 5 )
	fireEvent( "20eacc6c-e109-11e8-9f32-f2801f1b9fd3", "AWS", "Volume cStor Create", "Success", "Size", 50 )
	fireEvent( "20eacc6c-e109-11e8-9f32-f2801f1b9fd3", "AWS", "Volume Jiva Delete", "Success", "Size", 5 )
}
