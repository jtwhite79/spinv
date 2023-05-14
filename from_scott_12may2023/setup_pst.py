import numpy as np
import pandas as pd
import pyemu

input_files = ["parameters.csv"]
tpl_files = []
par_dfs = []
df = pd.read_csv("parameters.csv")
xvals = df.X.unique()
xvals.sort()
zvals = df.Z.unique()
zvals.sort()
xdict = {x:i for i,x in enumerate(xvals)}
assert len(xdict) == len(xvals)
zdict = {z:i for i,z in enumerate(zvals)}
assert len(zdict) == len(zvals)


for input_file in input_files:
	tag = input_file.split(".")[0].split("_")[-1].lower()
	tpl_file = input_file+".tpl"
	ftpl = open(tpl_file,'w')
	fin = open(input_file,'r')
	ftpl.write("ptf ~\n")
	data = {"parnme":[],"x":[],"z":[],"parval1":[],"pargp":[]}
	hline = fin.readline()
	ftpl.write(hline.strip()+"\n")
	header = hline.lower().strip().split(",")
	#ftpl.write(",".join(header)+"\n")
	for line in fin:
		raw = line.strip().split(",")
		name,x,z= raw[0],raw[1],raw[2]
		ftpl.write(",".join(raw[:3]))
		pos = 3
		for h,r in zip(header[3:],raw[3:]):
			pname = "pname:"+h + "_x:"+x +"_z:"+z + "_i:{0}_j:{1}".format(xdict[float(x)],zdict[float(z)])
			raw[pos] = "~"+pname+"~"
			ftpl.write(",{0}".format(raw[pos]))
			data["parnme"].append(pname)
			data["x"].append(float(x))
			data["z"].append(float(z))
			data["parval1"].append(float(r))
			data["pargp"].append(h)
			pos += 1
		ftpl.write("\n")
	ftpl.close()
	tpl_files.append(tpl_file)
	fin.close()
	par_df = pd.DataFrame(data)
	par_df.index = par_df.parnme
	par_df.loc[:,"y"] = par_df.z.values
	par_dfs.append(par_df)

ins_files = []
output_files = ["output.csv"]
for output_file in output_files:
	tag = "v"
	ins_file = output_file+".ins"
	fins = open(ins_file,'w')
	fout = open(output_file,'r')
	fins.write("pif ~\n")
	iobs = 0
	hline = fout.readline()
	header = hline.strip().split(",")
	dist_dict = {}
	for line in fout:
		raw = line.strip().split(',')
		if len(raw) == 0:
			break
		#oname = "v_x:"+raw[0]+"_z:"+raw[1]
		#fins.write("l1 w w !{0}!\n".format(oname))
		oname = "v_dist:{0:<15.6f}_iobs:{1}".format(float(raw[0]),iobs).strip()
		fins.write("l1 ~,~ !{0}!\n".format(oname))
		dist_dict[oname] = float(raw[0])
		iobs += 1
	fout.close()
	fins.close()
	ins_files.append(ins_file)

pst = pyemu.Pst.from_io_files(tpl_files,input_files,ins_files,output_files)
pst.model_command = "matlab -nodesktop -nosplash -r \"Rio_Grande_Forward_Model_to_Jeremy.m\""
pst.noptmax = 0
pst.write("pest.pst")

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

odata = pd.read_csv("dobs.csv",index_col=0)
obs = pst.observation_data
#obs.loc[:,"dist"] = obs.obsnme.apply(lambda x: dist_dict[x])
#obs.loc[:,"obsval"] = obs.dist.apply(lambda x: odata.loc[x])
pst.observation_data.loc[:,"obsval"] = odata.values

v = pyemu.geostats.ExpVario(1.0,1000,10.0,90)
gs = pyemu.geostats.GeoStruct(variograms=[v])
#sd = {gs:par_dfs}
sd = {}
pnames = par.pname.unique()
pnames.sort()
dfs = []
for pname in pnames:
	p = par.loc[par.pname==pname,:].copy()
	dfs.append(p)
sd[gs] = dfs
pe = pyemu.helpers.geostatistical_draws(pst,sd)
pe.enforce()
print(pe._df.min())
print(pe._df.max())
pe.to_csv("prior.csv")
pst.pestpp_options["ies_par_en"] = "prior.csv"
pst.pestpp_options["ies_num_reals"] = 20
pst.pestpp_options["ies_lambda_mults"] = [0.1,1.0,10.0]
pst.pestpp_options["lambda_scale_fac"] = [0.5,1.0]


pst.write("pest.pst")


