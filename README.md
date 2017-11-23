# Commands

```
docker run --name artefhack -p 8545:8545 -p 30301:30301 -p 8181:8181 -p 8546:8546 -p 30302:30302 -p 8182:8182 -p 8451:8451 -v ~/Bureau/artefhack-vol:/data -td mboisnard/artefhack:latest bash

docker exec -it artefhack bash

cd /data
git clone https://github.com/mboisnard/ArtefHack
cd ArtefHack/hackathon
npm install
testrpc

docker exec -it artefhack bash

cd ArtefHack/hackathon
truffle migrate
source ~/.venv-py3/bin/activate
python3 test.py
```