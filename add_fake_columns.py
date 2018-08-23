import sys

with open(sys.argv[1],"r") as f:
    lines = f.readlines()
    with open(sys.argv[2],"w") as of:
        of.write("chrom\tclassifiedWinStart\tclassifiedWinEnd\tbigWinRange\t{}".format(lines[0]))
        for l in lines[1:]:
            of.write("chr1\t1\t100\t1-100\t{}".format(l))
