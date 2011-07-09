import sys,subprocess
from glob import glob
CTMCONV = 'ctmconv';
DBDIR = '/home/joschu/Data/grasping/benchmark/db';
OBJDIR = '/home/joschu/Data/grasping/obj';

for modelnum in map(int,sys.argv[1:]):

    off_file = glob('%s/*/m%i/m%i.off'%(DBDIR,modelnum,modelnum))[0]
    obj_file = '%s/m%i.obj'%(OBJDIR,modelnum);
    cmd = '%s %s %s --calc-normals'%(CTMCONV,off_file,obj_file)


    print(cmd)
    subprocess.check_call(cmd,shell=True)
