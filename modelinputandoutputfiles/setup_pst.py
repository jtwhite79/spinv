import numpy as np
import pandas as pd
import pyemu

input_files = ["Input_S.txt","Input_K.txt"]
tpl_files = []
par_dfs = []
for input_file in input_files:
	tag = input_file.split(".")[0].split("_")[-1].lower()
	tpl_file = input_file+".tpl"
	ftpl = open(tpl_file,'w')
	fin = open(input_file,'r')
	ftpl.write("ptf ~\n")
	data = {"parnme":[],"x":[],"z":[],"parval1":[],"pargp":[]}
	for line in fin:
		raw = line.strip().split()
		x,z,val = [float(r) for r in raw]
		pname = tag + "_x:"+raw[0] +"_z:"+raw[1]
		raw[-1] = " ~    "+pname+"    ~"
		ftpl.write(" ".join(raw)+"\n")
		data["parnme"].append(pname)
		data["x"].append(x)
		data["z"].append(z)
		data["parval1"].append(val)
		data["pargp"].append(tag)
	ftpl.close()
	tpl_files.append(tpl_file)
	fin.close()
	par_df = pd.DataFrame(data)
	par_df.index = par_df.parnme
	par_df.loc[:,"y"] = par_df.z.values
	par_dfs.append(par_df)

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
		if len(raw) == 0:
			break
		oname = "v_x:"+raw[0]+"_z:"+raw[1]
		fins.write("l1 w w !{0}!\n".format(oname))
	fout.close()
	fins.close()
	ins_files.append(ins_file)
pst = pyemu.Pst.from_io_files(tpl_files,input_files,ins_files,output_files)
pst.model_command = "matlab -nodesktop -nosplash -r \"Rio_Grande_Forward_Model_to_Jeremy.m\""
pst.noptmax = 0
par = pst.parameter_data
for par_df in par_dfs:
	for col in par_df:
		if col == "parnme":
			continue
		par.loc[par_df.index,col] = par_df.loc[:,col].values

kpar = par.loc[par.parnme.str.contains("k_"),:]
par.loc[kpar.parnme,"parubnd"] = 100.0
par.loc[kpar.parnme,"parlbnd"] = 1e-7
par.loc[kpar.parnme,"parval1"] = 1e-3

spar = par.loc[par.parnme.str.contains("s_"),:]
par.loc[spar.parnme,"parubnd"] = 1.0
par.loc[spar.parnme,"parlbnd"] = 0.001
par.loc[spar.parnme,"parval1"] = 0.1



v = pyemu.geostats.ExpVario(1.0,1000,10.0,90)
gs = pyemu.geostats.GeoStruct(variograms=[v])
sd = {gs:par_dfs}
pe = pyemu.helpers.geostatistical_draws(pst,sd)
pe.enforce()
print(pe._df.min())
print(pe._df.max())
pe.to_csv("prior.csv")
pst.pestpp_options["ies_par_en"] = "prior.csv"


pst.write("pest.pst")


