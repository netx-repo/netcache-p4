header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}
header ipv4_t ipv4;

header_type tcp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        seqNo : 32;
        ackNo : 32;
        dataOffset : 4;
        res : 3;
        ecn : 3;
        ctrl : 6;
        window : 16;
        checksum : 16;
        urgentPtr : 16;
    }   
}
header tcp_t tcp;

header_type udp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        len : 16;
        checksum : 16;
    }
}
header udp_t udp;

header_type nc_hdr_t {
    fields {
        op: 8;
        key: 128;
    }
}
header nc_hdr_t nc_hdr;

header_type nc_load_t {
    fields {
        load_1: 32;
        load_2: 32;
        load_3: 32;
        load_4: 32;
    }
}
header nc_load_t nc_load;

/*
    The headers for value are defined in value.p4
    k = 1, 2, ..., 8
    header_type nc_value_{k}_t {
        fields {
            value_{k}_1: 32;
            value_{k}_2: 32;
            value_{k}_3: 32;
            value_{k}_4: 32;
        }
    }
*/
