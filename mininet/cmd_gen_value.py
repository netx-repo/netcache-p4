path_to_cmd = "commands_value.txt"

f = open(path_to_cmd, "w")
for i in range(1, 9):
    for j in range(1, 5):
        f.write("table_set_default read_value_%d_%d read_value_%d_%d_act\n" % (i, j, i, j))
        f.write("table_set_default add_value_header_%d add_value_header_%d_act\n" % (i, i))
        f.write("table_set_default write_value_%d_%d write_value_%d_%d_act\n" % (i, j, i, j))
        f.write("table_set_default remove_value_header_%d remove_value_header_%d_act\n" % (i, i))
f.flush()
f.close()
