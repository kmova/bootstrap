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
	client.ClientID(cid).
		DataSource(ds).
		ApplicationInstallerID( aid ).
		ApplicationID(ai).
		ApplicationVersion(av)


	client.ApplicationName(eSubType).
		DocumentTitle(eId)

	event := ga.NewEvent(eType, eState)
	event.
		Label(eLabel).
		Value(eVal)


	err = client.Send(event)
	//err = client.Send(ga.NewEvent("Foo", "Bar").Label("Bazz"))
	if err != nil {
		panic(err)
	}
	println("Event fired!")
}

func main() {

	/**
	//Install Events - Init or Running
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.2",
			"Install", "Linux-AMD64", "20eacc6c-0001-0000-0000-f2801f1b9fd1",
			"Init", 
			"Nodes", 1 )
	fireEvent( "20eacc6c-0002-0000-0000-f2801f1b9fd1", "AWS", "1.10",
			"OpenEBS", "0.8.0",
			"Install", "Linux-AMD64", "20eacc6c-0002-0000-0000-f2801f1b9fd1",
			"Init", 
			"Nodes", 1 )
	fireEvent( "20eacc6c-0003-0000-0000-f2801f1b9fd1", "GKE", "1.9.7",
			"OpenEBS", "0.7.1",
			"Install", "Linux-AMD64", "20eacc6c-0003-0000-0000-f2801f1b9fd1",
			"Init", 
			"Nodes", 1 )
	**/



	/**
	//Install Events - Running
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.2",
			"Install", "Linux-AMD64", "20eacc6c-0001-0000-0000-f2801f1b9fd1",
			"Running", 
			"Nodes", 1 )
	**/

	/**
	//Install Events - Init (upgraded minikube openebs version)
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.3",
			"Install", "Linux-AMD64", "20eacc6c-0001-0000-0000-f2801f1b9fd1",
			"Init", 
			"Nodes", 1 )
	**/

	/**
	//Volume Provisioning Events
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.2",
			"Volume Provisioned", "Jiva", "20eacc6c-0001-0001-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 10 )

	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.2",
			"Volume Provisioned", "cStor", "20eacc6c-0001-0002-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 100 )

	//Volume Deprovisioning Events
	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.2",
			"Volume Deprovisioned", "Jiva", "20eacc6c-0001-0001-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 10 )

	fireEvent( "20eacc6c-0001-0000-0000-f2801f1b9fd1", "Minikube", "1.12",
			"OpenEBS", "0.8.2",
			"Volume Deprovisioned", "cStor", "20eacc6c-0001-0002-0000-f2801f1b9fd1",
			"Success", 
			"Capacity", 100 )
	**/
}
