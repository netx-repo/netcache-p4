action ethernet_set_mac_act (smac, dmac) {
    modify_field (ethernet.srcAddr, smac);
    modify_field (ethernet.dstAddr, dmac);
}
table ethernet_set_mac {
    reads {
        standard_metadata.egress_port: exact;
    }
    actions {
        ethernet_set_mac_act;
    }
}
