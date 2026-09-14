import numpy
import random

def selection(S,k):
	v = S[random.randint(0,len(S)-1)]
	sl=[]
	sv=[]
	sr=[]
	for i in S:
		if i<v:
			sl.append(i)
		elif i>v:
			sr.append(i)
		else:
			sv.append(i)
	#print(f'v={v}, S = {S}\nsl = {sl}, sv = {sv}, sr = {sr}')
	if k<len(sl):
		return selection(sl,k)
	elif k>len(sl)+len(sv):
		return selection(sr,k-len(sl)-len(sv))
	else:
		return v;

while 1:
	n = int(input(f'enter n size: '))
	k = int(input(f'enter kth int: '))
	S = []
	for i in range(n):
		S.append(random.randint(0,n-1))
	a = selection(S,k)
	print(f'S = {S}')
	print(f's = {numpy.sort(S)}')
	print(f'the {k}th int in S is {a}.')
