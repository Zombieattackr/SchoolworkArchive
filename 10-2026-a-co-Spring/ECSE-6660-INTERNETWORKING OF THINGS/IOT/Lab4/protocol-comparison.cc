
#include <fstream>
#include <iostream>

#include "ns3/aodv-module.h"
#include "ns3/applications-module.h"
#include "ns3/core-module.h"
#include "ns3/dsdv-module.h"
#include "ns3/dsr-module.h"
#include "ns3/internet-module.h"
#include "ns3/mobility-module.h"
#include "ns3/network-module.h"
#include "ns3/olsr-module.h"
#include "ns3/yans-wifi-helper.h"
#include "RoutingExperiment.h"

using namespace ns3;
using namespace dsr;

/***
 *  Bash command to run
 *  
 *  protocol: 0: DSR, 1: AODV
 *  speed: an integer between 1 and 20 (inclusive)
 *  ./ns3 run "protocol-comparison --protocol=1 --CSVfileName='AODV-pkt.csv' --speed='10'" 
 *  ./ns3 run "protocol-comparison --protocol=0 --CSVfileName='DSR-pkt.csv' --speed='13'"
 */

int main(int argc, char *argv[]) {
    RoutingExperiment experiment;
    std::string CSVfileName = experiment.CommandSetup(argc, argv);

    //blank out the last output file and write the column headers
    std::ofstream out(CSVfileName.c_str());
    out << "SimulationSecond,"
        << "ReceiveRate,"
        << "PacketsReceived,"
        << "NumberOfSinks,"
        << "RoutingProtocol,"
        << "TransmissionPower,"
        << "NodeSpeed" 
        << std::endl;
    out.close();

    int nSinks = 10;
    double txp = 7.5;

    experiment.Run(nSinks, txp, CSVfileName);
}
