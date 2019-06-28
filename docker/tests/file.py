import sys
from LDMX.Framework import ldmxcfg
from LDMX.EventProc.ecalDigis import ecalDigis
from LDMX.EventProc.simpleTrigger import simpleTrigger
from LDMX.EventProc.hcalDigis import hcalDigis
from LDMX.EventProc.trackerHitKiller import trackerHitKiller
p=ldmxcfg.Process("recon")
p.libraries.append("libEventProc.so")
ecalVeto = ldmxcfg.Producer("ecalVeto", "ldmx::EcalVetoProcessor")
ecalVeto.parameters["num_ecal_layers"] = 34
ecalVeto.parameters["do_bdt"] = 0
ecalVeto.parameters["bdt_file"] = "fid_bdt.pkl"
ecalVeto.parameters["disc_cut"] = 0.94
ecalVeto.parameters["cellxy_file"] = "cellxy.txt"
ecalVeto.parameters["collection_name"] = "ecalVeto.dockertest"
hcalVeto = ldmxcfg.Producer("hcalVeto", "ldmx::HcalVetoProcessor")
hcalVeto.parameters["pe_threshold"] = 8.0
hcalVeto.parameters["collection_name"] = "hcalVeto.dockertest"
simpleTrigger.parameters["threshold"] = 1500.0
simpleTrigger.parameters["end_layer"] = 20
findable_track = ldmxcfg.Producer("findable", "ldmx::FindableTrackProcessor")
p.sequence=[ecalDigis, hcalDigis, ecalVeto, simpleTrigger, trackerHitKiller, findable_track]
p.inputFiles=["output.root"]
p.outputFiles=["file_tskim_recon.root"]
p.printMe()
p.histogramFile="histo.root"
