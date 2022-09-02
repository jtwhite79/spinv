import pyemu

input_files = ["Input_S.txt","Input_K.txt"]
tpl_files = []
for input_file in input_files:
	tag = input_file.split(".")[0].split("_")[-1].lower()
	tpl_file = input_file+".tpl"
	ftpl = open(tpl_file,'w')
	fin = open(input_file,'r')
	ftpl.write("ptf ~\n")
	data = {"parnme":[],"x":[],"y":[],"parval1":[]}
	for line in fin:
		raw = line.strip().split()
		x,y,val = [float(r) for r in raw]
		pname = tag + "_x:"+raw[0] +"_z:"+raw[1]
		raw[-1] = " ~    "+pname+"    ~"
		ftpl.write(" ".join(raw)+"\n")
		data["parnme"].append(pname)
		data["x"].append(x)
		data["y"].append(y)
		data["parval1"].append(val)
	ftpl.close()
	tpl_files.append(tpl_file)
	fin.close()


output_files = ["Output_V.txt"]
ins_files = []
for output_file in output_files:
	tag = output_file.split(".")[0].split("_")[-1].lower()
	ins_file = output_file+".ins"
	fins = open(ins_file,'w')
	fout = open(output_file,'r')
	fins.write("pif ~\n")
	for line in fout:
		raw = line.strip().split()
		oname = "v_x:"+raw[0]+"_z:"+raw[1]
		fins.write("l1 w w !{0}!\n".format(oname))
	fout.close()
	fins.close()
	ins_files.append(ins_file)

pst = pyemu.Pst.from_io_files(tpl_files,input_files,ins_files,output_files)


