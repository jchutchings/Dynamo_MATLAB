#!/usr/bin/env python3

import re
import argparse
import numpy as np
import os

# Initialize the argument parser
parser = argparse.ArgumentParser(description="Generate Dynamo console commands from a MATLAB script.")

# Add positional arguments - minimal requirements
parser.add_argument('matlab_script', type=str, help="MATLAB script name")
parser.add_argument('--run', type=int, default=1, help="Whether to execute Dynamo commands or not, boolean", required=True)

# Parse the arguments
args = parser.parse_args()

# Construct the greeting message
if args.run==1:
    greeting_message = f"Creating Dynamo commands from '{args.matlab_script}' for execution."
else:
    greeting_message = f"Creating Dynamo commands from '{args.matlab_script}' without execution."

# Print the final greeting message
print(greeting_message)


# first pass - strip comments:
firstlist = []
with open(args.matlab_script,'r') as file:
    for line in file:
        linestrip = line.strip()
        if linestrip.startswith('%'):
            continue
        elif linestrip=="":
            continue
        else:
            if "%" in linestrip:
                linestripsplit = re.split('%',linestrip)
                linestrip = linestripsplit[0]
        firstlist.append(linestrip)

# second pass - identify loops
blockcounter = 0
blocklist = []
for idx,i in enumerate(firstlist):
    if i.startswith('if') or i.startswith('for'):
        blockcounter+=1
        if blockcounter==1:
            blockliststart=idx
    elif i.startswith('end'):
        blockcounter-=1
        if blockcounter==0:
            blocklistend=idx
            blocklist.append((blockliststart,blocklistend))
    else:
        continue

# third pass - add semicolons within loop blocks
secondlist=[]
for first,second in blocklist:
    oneliner = "";
    for j in range(first,second+1):
        if not firstlist[j].strip().endswith(";"):
            oneliner=oneliner+firstlist[j]+";"
        else:
            oneliner=oneliner+firstlist[j]
    secondlist.append(oneliner)

# fourth pass - loop all lines and add loop blocks
thirdlist = []
lower = [0]
for idx,i in enumerate(blocklist):
    lower.append(i[1] + 1)
noloopblocks = []
for idx,i in enumerate(lower):
    if idx >= len(blocklist):
        noloopblocks.append((i,len(firstlist)))
    else:
        noloopblocks.append((i,blocklist[idx][0]))

# fifth pass - build final list
to_file = []
for idx,i in enumerate(noloopblocks):
    for j in range(noloopblocks[idx][0],noloopblocks[idx][1]):
        to_file.append(firstlist[j])
    if idx < len(secondlist):
        to_file.append(secondlist[idx])
with open(f'{args.matlab_script[:-2]}.sh', 'w') as file:
    file.write("dynamo <<EOF \n")
    for item in to_file:
        file.write(item + '\n')
    file.write("EOF")

 # run script?
if args.run==1:
    os.system(f'chmod u+x {args.matlab_script[:-2]}.sh')
    os.system(f'./{args.matlab_script[:-2]}.sh >> {args.matlab_script[:-2]}.log &')
