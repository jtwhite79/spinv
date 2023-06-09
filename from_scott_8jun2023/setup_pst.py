import numpy as np
import pandas as pd
import pyemu


def setup_pst():
	input_files = ["Input_K.txt","Input_q.txt","Input_th.txt"]
	tpl_files = []
	par_dfs = []

	for input_file in input_files:
		tag = input_file.split(".")[0].split("_")[-1].lower()
		df = pd.read_csv(input_file,delim_whitespace=True,header=None,names=["x","z","val"])
		xvals = df.x.astype(float).unique()
		xvals.sort()
		xdict = {xvals[i]:i for i in range(len(xvals))}
		zvals = df.z.astype(float).unique()
		zvals.sort()
		zdict = {zvals[i]:i for i in range(len(zvals))}
		
		tpl_file = input_file+".tpl"
		ftpl = open(tpl_file,'w')
		fin = open(input_file,'r')
		ftpl.write("ptf ~\n")
		data = {"parnme":[],"x":[],"z":[],"parval1":[],"pargp":[],"partrans":[]}
		#hline = fin.readline()
		#ftpl.write(hline.strip()+"\n")
		#header = hline.lower().strip().split(",")
		header = ["x","z","val"]
		#ftpl.write(",".join(header)+"\n")
		for line in fin:
			if line.strip() == "":
				break
			print(input_file,line)
			raw = line.strip().split()
			x,z,v= raw[0],raw[1],raw[2]
			#ftpl.write(",".join(raw[:3]))
			pname = "pname:"+tag + "_x:"+x +"_z:"+z + "_i:{0}_j:{1}".format(xdict[float(x)],zdict[float(z)])
			raw[-1] = "~  " + pname + " ~"			
		
			ftpl.write(" ".join(raw) + "\n")
			data["parnme"].append(pname)
			data["x"].append(float(x))
			data["z"].append(float(z))
			data["parval1"].append(float(v))
			data["pargp"].append(tag)
			data["partrans"].append("none")
			
		ftpl.close()
		tpl_files.append(tpl_file)
		fin.close()
		par_df = pd.DataFrame(data)
		par_df.index = par_df.parnme
		par_df.loc[:,"y"] = par_df.z.values
		par_dfs.append(par_df)

	ins_files = []
	output_files = ["Output_V.txt"]
	for output_file in output_files:
		tag = "v"
		ins_file = output_file+".ins"
		fins = open(ins_file,'w')
		fout = open(output_file,'r')
		fins.write("pif ~\n")
		iobs = 0
		for line in fout:
			raw = line.strip()
			if len(raw) == 0:
				break
			#oname = "v_x:"+raw[0]+"_z:"+raw[1]
			#fins.write("l1 w w !{0}!\n".format(oname))
			oname = "v_iobs:{0}".format(iobs).strip()
			fins.write("l1 !{0}!\n".format(oname))
			#dist_dict[oname] = float(raw[0])
			iobs += 1
		fout.close()
		fins.close()
		ins_files.append(ins_file)

	pst = pyemu.Pst.from_io_files(tpl_files,input_files,ins_files,output_files)
	pst.model_command = "matlab -nodesktop -nosplash -r \"Rio_Grande_Forward_Model_to_Jeremy.m\""
	pst.noptmax = 0
	pst.pestpp_options["debug_parse_only"] = True
	pst.write("pest.pst",version=2)
	pyemu.os_utils.run("pestpp-ies pest.pst")
	pst.pestpp_options.pop("debug_parse_only")

	par = pst.parameter_data
	for par_df in par_dfs:
		for col in par_df:
			if col == "parnme":
				continue
			par.loc[par_df.index,col] = par_df.loc[:,col].values

	for pname in par.pname.unique():
		ppar = par.loc[par.pname==pname,:].copy()
		par.loc[ppar.parnme,"parubnd"] = ppar.parval1.max() * 5.0
		par.loc[ppar.parnme,"parlbnd"] = ppar.parval1.min() / 5.0

	#odata = pd.read_csv("dobs.csv",index_col=0)
	#obs = pst.observation_data
	#obs.loc[:,"dist"] = obs.obsnme.apply(lambda x: dist_dict[x])
	#obs.loc[:,"obsval"] = obs.dist.apply(lambda x: odata.loc[x])
	#pst.observation_data.loc[:,"obsval"] = odata.values

	v = pyemu.geostats.ExpVario(1.0,100,10.0,90)
	gs = pyemu.geostats.GeoStruct(variograms=[v])
	#sd = {gs:par_dfs}
	sd = {}
	pnames = par.pname.unique()
	pnames.sort()
	dfs = []
	for pname in pnames:
		p = par.loc[par.pname==pname,:].copy()
		x = p.pop("x")
		p.loc[:,"x"] = np.array(x.values,dtype=float)
		p.loc[:,"y"] = np.array(p.y.values,dtype=float)
		p.loc[:,"parnme"] = p.pop("parnme").values
		p.loc[:,"name"] = p.parnme.values
		#print(p.x.values.min(),p.x.values.max())
		print(p.shape)
		print(len(set(p.parnme.tolist())))

		dfs.append(p)
	sd[gs] = dfs
	print(dfs)
	pe = pyemu.helpers.geostatistical_draws(pst,sd)
	pe.enforce()
	pe.to_csv("prior.csv")
	print(pe.shape)
	assert pe.shape[1] == pst.npar
	pst.pestpp_options["ies_par_en"] = "prior.csv"
	pst.pestpp_options["ies_num_reals"] = 100
	pst.control_data.noptmax = 5


	pst.write("pest.pst",version=2)

def plot_real():
	import matplotlib.pyplot as plt
	pst = pyemu.Pst("pest.pst")
	pe = pd.read_csv("prior.csv",index_col=0)
	par = pst.parameter_data
	par.loc[:,'i'] = par.i.astype(int)
	par.loc[:,'j'] = par.j.astype(int)
	par.loc[:,"x"] = par.x.astype(float)
	par.loc[:, "y"] = par.y.astype(float)

	#nrow = par.i.max()+1
	#ncol = par.j.max()+1
	pnames = par.pname.unique()
	pnames.sort()

	fig,axes = plt.subplots(len(pnames),1,figsize=(10,10))
	if len(pnames) == 1:
		axes = [axes]
	for pname,ax in zip(pnames,axes):
		ppar = par.loc[par.pname==pname,:].copy()
		#arr = np.zeros((nrow,ncol))-1e+10
		#arr[ppar.i,ppar.j] = pe.loc[pe.index[0],ppar.parnme]
		#arr[arr==-1e10] = np.nan
		#print(np.nanmin(arr),np.nanmax(arr),np.nanmean(arr),np.nanstd(arr))
		#print(arr)
		#cb = ax.imshow(arr)
		#plt.colorbar(cb,ax=ax)
		ax.scatter(ppar.x,ppar.y,marker="o",c=pe.loc[pe.index[0],ppar.parnme].values)
		ax.set_title(pname)
		ax.set_aspect(50)
	plt.tight_layout()
	plt.savefig("real.pdf")

if __name__ == "__main__":
	setup_pst()
	plot_real()





