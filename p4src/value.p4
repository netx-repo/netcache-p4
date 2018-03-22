#define HEADER_VALUE(i) \
    header_type nc_value_##i##_t { \
        fields { \
            value_##i##_1: 32; \
            value_##i##_2: 32; \
            value_##i##_3: 32; \
            value_##i##_4: 32; \
        } \
    } \
    header nc_value_##i##_t nc_value_##i;

#define PARSER_VALUE(i, ip1) \
    parser parse_nc_value_##i { \
        extract (nc_value_##i); \
        return parse_nc_value_##ip1; \
    }

#define REGISTER_VALUE_SLICE(i, j) \
    register value_##i##_##j##_reg { \
        width: 32; \
        instance_count: NUM_CACHE; \
    }

#define REGISTER_VALUE(i) \
    REGISTER_VALUE_SLICE(i, 1) \
    REGISTER_VALUE_SLICE(i, 2) \
    REGISTER_VALUE_SLICE(i, 3) \
    REGISTER_VALUE_SLICE(i, 4) 

#define ACTION_READ_VALUE_SLICE(i, j) \
    action read_value_##i##_##j##_act() { \
        register_read(nc_value_##i.value_##i##_##j, value_##i##_##j##_reg, nc_cache_md.cache_index); \
    }

#define ACTION_READ_VALUE(i) \
    ACTION_READ_VALUE_SLICE(i, 1) \
    ACTION_READ_VALUE_SLICE(i, 2) \
    ACTION_READ_VALUE_SLICE(i, 3) \
    ACTION_READ_VALUE_SLICE(i, 4)

#define TABLE_READ_VALUE_SLICE(i, j) \
    table read_value_##i##_##j { \
        actions { \
            read_value_##i##_##j##_act; \
        } \
    }

#define TABLE_READ_VALUE(i) \
    TABLE_READ_VALUE_SLICE(i, 1) \
    TABLE_READ_VALUE_SLICE(i, 2) \
    TABLE_READ_VALUE_SLICE(i, 3) \
    TABLE_READ_VALUE_SLICE(i, 4)

#define ACTION_ADD_VALUE_HEADER(i) \
    action add_value_header_##i##_act() { \
        add_to_field(ipv4.totalLen, 16);\
        add_to_field(udp.len, 16);\
        add_header(nc_value_##i); \
    }

#define TABLE_ADD_VALUE_HEADER(i) \
    table add_value_header_##i { \
        actions { \
            add_value_header_##i##_act; \
        } \
    }

#define ACTION_WRITE_VALUE_SLICE(i, j) \
    action write_value_##i##_##j##_act() { \
        register_write(value_##i##_##j##_reg, nc_cache_md.cache_index, nc_value_##i.value_##i##_##j); \
    }

#define ACTION_WRITE_VALUE(i) \
    ACTION_WRITE_VALUE_SLICE(i, 1) \
    ACTION_WRITE_VALUE_SLICE(i, 2) \
    ACTION_WRITE_VALUE_SLICE(i, 3) \
    ACTION_WRITE_VALUE_SLICE(i, 4)

#define TABLE_WRITE_VALUE_SLICE(i, j) \
    table write_value_##i##_##j { \
        actions { \
            write_value_##i##_##j##_act; \
        } \
    }

#define TABLE_WRITE_VALUE(i) \
    TABLE_WRITE_VALUE_SLICE(i, 1) \
    TABLE_WRITE_VALUE_SLICE(i, 2) \
    TABLE_WRITE_VALUE_SLICE(i, 3) \
    TABLE_WRITE_VALUE_SLICE(i, 4)

#define ACTION_REMOVE_VALUE_HEADER(i) \
    action remove_value_header_##i##_act() { \
        subtract_from_field(ipv4.totalLen, 16);\
        subtract_from_field(udp.len, 16);\
        remove_header(nc_value_##i); \
    }

#define TABLE_REMOVE_VALUE_HEADER(i) \
    table remove_value_header_##i { \
        actions { \
            remove_value_header_##i##_act; \
        } \
    }

#define CONTROL_PROCESS_VALUE(i) \
    control process_value_##i { \
        if (nc_hdr.op == NC_READ_REQUEST and nc_cache_md.cache_valid == 1) { \
            apply (add_value_header_##i); \
            apply (read_value_##i##_1); \
            apply (read_value_##i##_2); \
            apply (read_value_##i##_3); \
            apply (read_value_##i##_4); \
        } \
        else if (nc_hdr.op == NC_UPDATE_REPLY and nc_cache_md.cache_exist == 1) { \
            apply (write_value_##i##_1); \
            apply (write_value_##i##_2); \
            apply (write_value_##i##_3); \
            apply (write_value_##i##_4); \
            apply (remove_value_header_##i); \
        } \
    }

#define HANDLE_VALUE(i, ip1) \
    HEADER_VALUE(i) \
    PARSER_VALUE(i, ip1) \
    REGISTER_VALUE(i) \
    ACTION_READ_VALUE(i) \
    TABLE_READ_VALUE(i) \
    ACTION_ADD_VALUE_HEADER(i) \
    TABLE_ADD_VALUE_HEADER(i) \
    ACTION_WRITE_VALUE(i) \
    TABLE_WRITE_VALUE(i) \
    ACTION_REMOVE_VALUE_HEADER(i) \
    TABLE_REMOVE_VALUE_HEADER(i) \
    CONTROL_PROCESS_VALUE(i)

#define FINAL_PARSER(i) \
    parser parse_nc_value_##i { \
        return ingress; \
    }

HANDLE_VALUE(1, 2)
HANDLE_VALUE(2, 3)
HANDLE_VALUE(3, 4)
HANDLE_VALUE(4, 5)
HANDLE_VALUE(5, 6)
HANDLE_VALUE(6, 7)
HANDLE_VALUE(7, 8)
HANDLE_VALUE(8, 9)
FINAL_PARSER(9)

header_type reply_read_hit_info_md_t {
    fields {
        ipv4_srcAddr: 32;
        ipv4_dstAddr: 32;
    }
}

metadata reply_read_hit_info_md_t reply_read_hit_info_md;

action reply_read_hit_before_act() {
    modify_field (reply_read_hit_info_md.ipv4_srcAddr, ipv4.srcAddr);
    modify_field (reply_read_hit_info_md.ipv4_dstAddr, ipv4.dstAddr);
}

table reply_read_hit_before {
    actions {
        reply_read_hit_before_act;
    }
}

action reply_read_hit_after_act() {
    modify_field (ipv4.srcAddr, reply_read_hit_info_md.ipv4_dstAddr);
    modify_field (ipv4.dstAddr, reply_read_hit_info_md.ipv4_srcAddr);
    modify_field (nc_hdr.op, NC_READ_REPLY);
}

table reply_read_hit_after {
    actions {
        reply_read_hit_after_act;
    }
}

control process_value {    
    if (nc_hdr.op == NC_READ_REQUEST and nc_cache_md.cache_valid == 1) {
        apply (reply_read_hit_before);
    }
    process_value_1();
    process_value_2();
    process_value_3();
    process_value_4();
    process_value_5();
    process_value_6();
    process_value_7();
    process_value_8();
    if (nc_hdr.op == NC_READ_REQUEST and nc_cache_md.cache_valid == 1) {
        apply (reply_read_hit_after);
    }
}
