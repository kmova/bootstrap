package main

import "github.com/jpillora/go-ogle-analytics"

func fireVolumeEvent( clusterId, nodeType, k8sVersion string,
	volumeType, openebsVersion string,
	volumeEvent, pvName string,
	replicaCount string, 
	capacityKey string, capacityVal int64 ) {

	client, err := ga.NewClient("UA-127388617-1")
	if err != nil {
		panic(err)
	}

	//client.ClientID("20eacc6c-e109-11e8-9f32-f2801f1b9fd1")
	client.ClientID(clusterId).
		CampaignSource("openebs-operator-kmova").
		CampaignContent(clusterId).
		CampaignID("campaign-id").
		CampaignName("campaign-name").
		CampaignKeyword("campaign-keyword").
		ApplicationID("OpenEBS").
		ApplicationVersion(openebsVersion).
		DataSource(nodeType).
		ApplicationName(volumeType).
		ApplicationInstallerID( k8sVersion ).
		DocumentTitle(pvName).
		DocumentHostName("hostname")

	event := ga.NewEvent(volumeEvent, replicaCount)
	event.Label(capacityKey)
	event.Value(capacityVal)


	err = client.Send(event)
	//err = client.Send(ga.NewEvent("Foo", "Bar").Label("Bazz"))
	if err != nil {
		panic(err)
	}
	println("Event fired!")
}

func main() {
	clusterId := "2ea928fa-b83c-463b-954c-d22b49c60da6"
	nodeType := "ubuntu 18.04.4 lts, 5.0.0-1032-gke"
	k8sVersion := "v1.15.11-gke.13"
	//k8sArch := ""
	openebsVersion := "1.11.0-f1152d3"

	volumeEvent := "volume-provision"
	volumeType := "jiva"
	pvName := "pvc-1827cb8d-8d45-4316-94ff-168ea312be61"
	replicaCount := "replica:3"

	fireVolumeEvent( clusterId, nodeType, k8sVersion,
			volumeType, openebsVersion,
			volumeEvent, pvName,
			replicaCount,
			"capacity", 2 ) 



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
