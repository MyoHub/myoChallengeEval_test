#!/bin/bash
GreenBK='\033[1;42m'
RedBK='\033[1;41m'
RC='\033[0m'
PassEvalAI=false
PassDocker=false

#check if docker is installed
docker info
if [ $? -eq 0 ]; then
    PassDocker=true
    printf "${GreenBK}Docker: Passed!${RC} \n"
else
    printf "${RedBK}Docker doesn't seem to be installed!${RC} \n"
    echo FAIL
fi


evalai challenges --participant
if [ $? -eq 0 ]; then
    PassEvalAI=true
    printf "${GreenBK}EvalAI: Passed!${RC} \n"
else
    printf "${RedBK}The team doesn't seem to have a valid EvalAI account!${RC} \n"
    echo FAIL
fi

if [ "$PassEvalAI" = "true" ] && [ "$PassDocker" = "true" ]; then
    # Install required dependences
    pip install -r requirements/agent.txt
    pip install grpcio grpcio-tools MyoSuite-1.1.0-py2.py3-none-any.whl

    export PYTHONPATH="./utils/:$PYTHONPATH"
    export PYTHONPATH="./agent/:$PYTHONPATH"
    export PYTHONPATH="./environment/:$PYTHONPATH"


    chmod u+r+x ./test/test_die_agent.sh
    chmod u+r+x ./test/test_bb_agent.sh

    ./test/test_die_agent.sh
    ./test/test_bb_agent.sh
fi
