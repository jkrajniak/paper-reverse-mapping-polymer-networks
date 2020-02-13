import os

steps = [x for x in os.listdir('.') if x.startswith('step')]
steps.sort()
data = {}

header = None
for step in steps:
    conv = [x for x in os.listdir(step) if x.endswith('dist.conv')]
    if not conv:
        continue
    conv.sort()
    tmp = {}
    for k in conv:
        tmp[k.split('.')[0]] = float(open(os.path.join(step, k)).read())
    tmp['total'] = float(sum(tmp.values())/len(tmp.values()))
    data[step] = tmp
    if not header and conv:
        header = [x.split('.')[0] for x in conv]
        header.append('total')

output = open('convergence.csv', 'w')

header_format = '{:^15}' + '{:<15}' * (len(header))
row_format = '{:^15}' + '{:<15.4}' * (len(header))

print(header_format.format('step', *header))

output.write(header_format.format('step', *header))
output.write('\n')

for step_id in sorted(data):
    conv = data[step_id]
    print(row_format.format(step_id, *map(conv.get, header)))
    output.write('{}\n'.format(row_format.format(step_id, *map(conv.get, header))))

output.close()
print('Saved to convergence.csv ...')
