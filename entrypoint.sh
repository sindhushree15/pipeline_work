#!/bin/sh -l
$level =""
if [ -z "$INPUT_PYTHON_VERSION" ]; then
    echo "🔥🔥🔥🔥🔥No python version provided🔥🔥🔥🔥🔥🔥"
    exit 1
else
    pyenv install $INPUT_PYTHON_VERSION
    pyenv global $INPUT_PYTHON_VERSION
    pyenv rehash
fi

if [ -z "$INPUT_LEVEL" ]; then
    echo "🔥🔥🔥🔥🔥No level provided🔥🔥🔥🔥🔥🔥"
else
    if ["$INPUT_LEVEL" -eq "low"]; then
        $level = '-l'
    elif ["$INPUT_LEVEL" -eq "medium"]; then
        $level = '-ll'
    else
        $level = '-lll'
    fi
fi  
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv virtualenv $INPUT_PYTHON_VERSION venv
pyenv activate venv

echo "🔥🔥🔥🔥🔥Running security check🔥🔥🔥🔥🔥🔥"
pip install bandit
mkdir -p $GITHUB_WORKSPACE/output
touch $GITHUB_WORKSPACE/output/security_report.txt
echo "🔥🔥🔥🔥🔥$level🔥🔥🔥🔥🔥🔥"
bandit -r $INPUT_PROJECT_PATH $level -o $GITHUB_WORKSPACE/output/security_report.txt -f 'txt'

if [ $? -eq 0 ]; then
    echo "🔥🔥🔥🔥Security check passed🔥🔥🔥🔥"
else
    echo "🔥🔥🔥🔥Security check failed🔥🔥🔥🔥"
    cat $GITHUB_WORKSPACE/output/security_report.txt
    if $INPUT_IGNORE_FAILURE; then
        exit 0
    else
        exit 1
    fi
fi
