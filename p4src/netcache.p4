#include "includes/defines.p4"
#include "includes/headers.p4"
#include "includes/parsers.p4"
#include "includes/checksum.p4"

#include "cache.p4"
#include "heavy_hitter.p4"
#include "value.p4"
#include "ipv4.p4"
#include "ethernet.p4"

control ingress {
    process_cache();
    process_value();
    
    apply (ipv4_route);
}

control egress {
    if (nc_hdr.op == NC_READ_REQUEST and nc_cache_md.cache_exist != 1) {
        heavy_hitter();
    }
    apply (ethernet_set_mac);
}
