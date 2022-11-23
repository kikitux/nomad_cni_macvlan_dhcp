from diagrams import Cluster, Diagram, Edge
from diagrams.aws.general import InternetAlt1 as Internet
from diagrams.aws.network import VPCRouter as Router
from diagrams.custom import Custom
from diagrams.generic.compute import Rack
from diagrams.generic.network import Router as AccessPoint
from diagrams.generic.network import Subnet
from diagrams.generic.network import Switch
from diagrams.generic.storage import Storage
from diagrams.generic.virtualization import Vmware
from diagrams.onprem.client import Client
from diagrams.onprem.client import User
from diagrams.onprem.compute import Server
from diagrams.onprem.container import LXC 
from diagrams.onprem.network import Nginx
from diagrams.onprem.compute import Nomad 
from diagrams.onprem.container import Docker

# Variables
title = "Nomad cni"
outformat = "png"
filename = "diagram"
direction = "TB"

with Diagram(
    name=title, direction=direction, filename=filename, outformat=outformat
) as diag:
    with Cluster("Network"):
        switch = Switch("LAN")

        with Cluster("DHCP VM"):
            enp0s8 = Custom("enp0s8", "./nic.png")

            #with Cluster("DHCP"):
            dhcp = Custom("dhcp", "./dhcp.png")
            switch - enp0s8 - dhcp

        with Cluster("Nomad Server"):
            
            enp0s8 = Custom("enp0s8", "./nic.png")
            switch - enp0s8

            with Cluster("Nomad"):
                nomad_server = Nomad("server")
                enp0s8 - [ nomad_server ]


        with Cluster("Nomad Client1"):
            enp0s8 = Custom("enp0s8", "./nic.png")
            switch - enp0s8

            with Cluster("Nomad"):
                nomad_client1 = Nomad("client")
                docker1 = Docker("job")
                enp0s8 - [  docker1, nomad_client1 ]

        with Cluster("Nomad Client2"):
            enp0s8 = Custom("enp0s8", "./nic.png")
            switch - enp0s8

            with Cluster("Nomad"):
                nomad_client2 = Nomad("client")
                docker1 = Docker("job")
                enp0s8 - [  docker1, nomad_client2 ]

