BEGIN {
    sent=0;
    recieved=0;
}
{
    time=$2;
    if ($1=="s" && $7=="tcp" && $4=="AGT") {
        sent++;
    }
    if ($1=="r" && $7=="tcp" && $4=="AGT") {
        recieved++;
    }
}
END {
    print "Packets Sent: " sent;
    print "Packets Recieved: " recieved;
    print "Packets Dropped ratio: " (sent-recieved)/sent;
}