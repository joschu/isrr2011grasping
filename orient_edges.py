import sys
import numpy as np

def orient_faces(v_f3):
    inlist = list(v_f3)
    outlist = []
    edges = set()
    
    ijk = inlist.pop()
    add_edges(ijk,edges)
    
    while len(inlist) > 0:
        print len(inlist)
        i,j,k = inlist.pop(0)
        if (i,j) in edges or (j,k) in edges or (k,i) in edges:
            outlist.append((j,i,k))
            add_edges((j,i,k),edges)
        elif (j,i) in edges or (k,j) in edges or (i,k) in edges:
            outlist.append((i,j,k))
            add_edges((i,j,k),edges)         
        else:
            inlist.append((i,j,k))
    return np.array(outlist)

def add_edges(triple,s):
    i,j,k = triple
    s.add((i,j))
    s.add((j,k))
    s.add((k,i))

if __name__ == "__main__":
    infile = sys.argv[1]
    outfile = sys.argv[2]
    v_f3 = np.loadtxt(infile,int)
    newv_f3 = orient_faces(v_f3)
    np.savetxt(outfile,newv_f3,fmt="%i")