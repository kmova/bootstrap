package main

import "github.com/jpillora/go-ogle-analytics"

func fireEvent( cid, ds, aid string,
	ai, av string,
	eType, eSubType, eId string,
	eState string, 
	eLabel string, eVal int64 ) {

	client, err := ga.NewClient("UA-127388617-1")
	if err != nil {
		panic(err)
	}

	//client.ClientID("20eacc6c-e109-11e8-9f32-f2801f1b9fd1")
	client.ClientID( cid )
	client.DataSource( ds )
	client.ApplicationInstallerID( aid )

	client.ApplicationID(ai)
	client.ApplicationVersion(av)


	client.ApplicationName(eSubType)
	client.DocumentTitle(eId)
	event := ga.NewEvent(eType, eState)
	event.Label( eLabel )
	event.Value( eVal )


	err = client.Send(event)
	//err = client.Send(ga.NewEvent("Foo", "Bar").Label("Bazz"))
	if err != nil {
		panic(err)
	}
	println("Event fired!")
}

func main() {

	//Install Events - either Init or Running
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.9.7",
			"OpenEBS", "0.7.2",
			"Install", "Linux", "AMD64",
			"Init", 
			"Nodes", 1 )

	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.9.7",
			"OpenEBS", "0.7.2",
			"Install", "Linux", "AMD64",
			"Running", 
			"Nodes", 1 )

	//Volume Provisioning Events
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.9.7",
			"OpenEBS", "0.7.2",
			"Volume Provisioned", "Jiva", "20eacc6c-0001-0001-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 10 )

	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.9.7",
			"OpenEBS", "0.7.2",
			"Volume Provisioned", "cStor", "20eacc6c-0001-0002-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 100 )

	//Volume Deprovisioning Events
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.9.7",
			"OpenEBS", "0.7.2",
			"Volume Deprovisioned", "Jiva", "20eacc6c-0001-0001-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 10 )

	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.9.7",
			"OpenEBS", "0.7.2",
			"Volume Deprovisioned", "cStor", "20eacc6c-0001-0002-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 100 )
}
