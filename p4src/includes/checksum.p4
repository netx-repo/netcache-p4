field_list ipv4_field_list {
    ipv4.version;
    ipv4.ihl;
    ipv4.diffserv;
    ipv4.totalLen;
    ipv4.identification;
    ipv4.flags;
    ipv4.fragOffset;
    ipv4.ttl;
    ipv4.protocol;
    ipv4.srcAddr;
    ipv4.dstAddr;
}
field_list_calculation ipv4_chksum_calc {
    input {
        ipv4_field_list;
    }
    algorithm : csum16;
    output_width: 16;
}
calculated_field ipv4.hdrChecksum {
    update ipv4_chksum_calc;
}

field_list udp_checksum_list {
    // IPv4 Pseudo Header Format. Must modify for IPv6 support.
    ipv4.srcAddr;
    ipv4.dstAddr;
    8'0;
    ipv4.protocol;
    udp.len;
    udp.srcPort;
    udp.dstPort;
    udp.len;
    // udp.checksum;
    payload;
}
field_list_calculation udp_checksum {
    input {
        udp_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}
calculated_field udp.checksum {
    update udp_checksum;
}
