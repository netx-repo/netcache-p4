path_to_cmd = "commands_cache.txt"
max_hot = 100

len_key = 16

f = open(path_to_cmd, "w")
for i in range(1, max_hot + 1, 2):
    x = i << ((len_key - 4) * 8)
    f.write("table_add check_cache_exist check_cache_exist_act %d => %d\n" % (x, i))
f.flush()
f.close()
