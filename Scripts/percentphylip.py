import sys
import json

matrix = {}

with open(sys.argv[1]) as fp:
	for line in fp:
		if line.startswith("#"): continue
		f = line.split()
		# Query ID first position
		query_id = f[0]
		# Subject ID second position
		subject_id = f[1]
		# percentage identity third position
		percent_id = float(f[2])
		if query_id not in matrix: matrix[query_id] = {}
		if subject_id not in matrix[query_id]: matrix[query_id][subject_id] = percent_id

# Begin some normalization on the percentage identity
for query_id in matrix:
	highest_id = max(list(matrix[query_id].values()))
	for subject_id in matrix[query_id]:
		matrix[query_id][subject_id] = 1-matrix[query_id][subject_id]/highest_id

# Do a filler for certain alignment issues
filler = None
for query_id in matrix:
	for subject_id in matrix:
		if subject_id not in matrix[query_id]:
			matrix[query_id][subject_id] = filler


default = 1
for query_id in matrix:
	for subject_id in matrix:

		if matrix[query_id][subject_id] and matrix[subject_id][query_id]:
			average = (matrix[query_id][subject_id] + matrix[subject_id][query_id])/2
			matrix[query_id][subject_id] = average
			matrix[subject_id][query_id] = average
		else:

			if matrix[query_id][subject_id] and matrix[subject_id][query_id] is None:
				matrix[query_id][subject_id] = default
				matrix[subject_id][query_id] = default
			elif matrix[query_id][subject_id] is None:
				matrix[query_id][subject_id] = matrix[subject_id][query_id]
			else:
				matrix[subject_id][query_id] = matrix[query_id][subject_id]

print(len(matrix))
for query_id in matrix:
	print(query_id, end="")
	for subject_id in matrix:
		print(f'\t{matrix[query_id][subject_id]:.3f}', end="")
	print()






