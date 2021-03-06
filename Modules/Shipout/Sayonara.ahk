﻿shipout := new Shipout()
if not Pwb := IETitle("ESOLBRANCH LIVE DB / \w+ / DLL Ver: " settings.Tesseract " / Page Ver: " settings.Tesseract) { ;*[T-Enhanced]
	msgbox,4144,,Failed to connect to Page
	return
}

if not FlowCode:= shipout.getFlowCode(Pwb) {
	msgbox,4144,,Failed to get job type
	return
}
if not ShipSite:= shipout.getShipSite(Pwb){
	msgbox,4144,,failed to get ship site
	return
}
if (FlowCode = "ZULUAW"){
	msgbox,4144,,This has already  been shipped
	return
}
if (shipsite = "ZULU") {
	zuluShipout(Pwb)
} else {
	oldShipout(Pwb)
}
return

class Shipout {
	getFlowCode(Pwb){
		frame := Pwb.document.all(10).contentWindow
		try {
			FlowCode := frame.document.getElementByID("cboJobFlowCode").value
			return FlowCode
		} catch {
			return False
		}
		
	}
	getShipSite(Pwb){
		frame := Pwb.document.all(10).contentWindow
		try {
			ShipSite := frame.document.getElementById("cboJobShipSiteNum").value
			return ShipSite
		} catch {
			return false
		}
	}
	
}


zuluShipout(Pwb){
	Loop{
		Try{
			frame := Pwb.document.all(10).contentWindow
			PageLoaded:= frame.document.getElementsByTagName("Label")[0].innertext
		}
	}Until (PageLoaded = "Job Details")
	PageLoaded:=""
	frame := Pwb.document.all(10).contentWindow
	frame.document.getElementByID("cboJobFlowCode").value:="ZULUAW"
	frame.document.getElementByID("cboCallAreaCode").value:="WSF"
	
	sleep, 250
	frame := Pwb.document.all(7).contentWindow
	Loop{
		Try{
			PageLoaded:= frame.document.getElementByID("cmdSubmit").value
		}
	}Until (PageLoaded = "submit")
	PageLoaded:=""
	frame.document.getElementById("cmdSubmit").click
	pageloading(pwb)
	sleep, 500
	frame := Pwb.document.all(10).contentWindow
	frame.document.getElementById("cboCallUpdAreaCode").value := "WSF"
	ModalDialogue()
	frame.document.getElementsByTagName("IMG")[35].click
	WinWaitClose,Popup List -- Webpage Dialog,,5
	frame := Pwb.document.all(7).contentWindow
	frame.document.getElementById("cmdSubmit").click
	PageAlert()
	sleep, 750
	pwb.navigate2("http://hypappbs005/SC5/SC_RepairJob/aspx/RepairJob_frameset.aspx")
	return
}

oldShipout(Pwb){ 
	frame := Pwb.document.all(10).contentWindow
	CallNum := ShipSite:= frame.document.getElementById("txtCallNum") .value
	ShipSite:= frame.document.getElementById("cboJobShipSiteNum") .value
	sleep, 250
	frame := Pwb.document.all(9).contentWindow
	frame.document.getElementById("lblJobShipOutWizard") .click
	IELoad(pwb)
	Pwb.document.getElementById("txtInputJobNum") .value :=CallNum
	Pwb.document.getElementById("cmdAddJobNum") .click
	Pwb.document.getElementById("cmdNext") .click
	IELoad(Pwb)
	Pwb.document.getElementById("cmdNext") .click
	IELoad(Pwb)
	Pwb.document.getElementsByTagName("INPUT")[48] .click
	SerialNumber:=Pwb.document.getElementbyID("cbaListCallSerNumLineArray").value
	ProdCode:=Pwb.document.getElementbyID("cbaListJobPartNumLineArray").value
	Pwb.document.getElementById("cmdFinish") .click
	PageAlert()
	IELoad(Pwb)
	Pwb.document.getElementsByTagName("INPUT")[40] .click
	Pwb.document.getElementById("cmdFinish") .click
	return
}