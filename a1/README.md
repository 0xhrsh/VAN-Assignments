# Assignment 1

## Facts:
- There are 2 RSUs (node 0 and node 1)
- Nodes 2, 3, 4, 5 are vehicles.

## How to run:
- To run the simulation:
    - `ns a1.tcl`
    - `nam out.nam`
- To see the analysis:
    - Throughput: `awk -f throughput.awk trace.tr` The average throughput should be about 1.29 kbps
    - Packet Delivery Ratio: `awk -f pdr.awk trace.tr` The pdr should be about 0.93
    - Packet Loss Ration: `awk -f plr.awk trace.tr` The plr should be about 0.04