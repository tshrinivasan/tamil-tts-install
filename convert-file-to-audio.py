import sys
import os
import time
import datetime

ssn_demo_path = "/home/shrini/Downloads/ssn_hts_demo"
#mp3_out_path = "/home/shrini/test"


ts = time.time()
timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y%m%d%H%M%S')

input_file = sys.argv[1]

filename = input_file.split(".txt")[0]

out_dir =  filename + "-" + timestamp

os.system("mkdir " + out_dir)

lines = open(input_file).readlines()

count_of_lines = len(lines)
digits = len(str(abs(count_of_lines))) +1 

line_count = 1

for line in lines:
	print line
	line = line.strip()
	os.chdir(ssn_demo_path)
	command = "./scripts/complete  '" + line + "' linux"
	print command
	os.system(command)
	os.system("lame wav/1.wav " + out_dir + "/"   + str(line_count).zfill(digits) + ".mp3")
	line_count = line_count + 1


os.chdir(out_dir)
os.system("cat *.mp3 > " + filename + ".mp3")
os.system("rm 0*.mp3")
