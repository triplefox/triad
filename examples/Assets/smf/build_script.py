import os
import json

result = []

def dbtree_walk(path, dirnames, filenames):
    if path!='./':
        prettypath = path[2:]
        for f in filenames:
            result.append([prettypath,"assets/smf/"+prettypath+"/"+f])

[dbtree_walk(a,b,c) for a,b,c in os.walk('./')]

writable = json.dumps(result)
f = open('song_db.json', 'w')
f.write(writable)
f.close()
print("wrote %s" % len(result))