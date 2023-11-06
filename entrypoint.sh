#!/bin/sh -l
$security_level =""
$security_confidence =""
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
        echo "LEVEl low🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_level = '-l'
    elif ["$INPUT_LEVEL" -eq "medium"]; then
        echo "LEVEl medium🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_level = '-ll'
    else
        echo "LEVEl high🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_level = '-lll'
    fi
fi 

if [ -z "$INPUT_CONFIDENCE" ]; then
    echo "🔥🔥🔥🔥🔥No level provided🔥🔥🔥🔥🔥🔥"
else
    if ["$INPUT_CONFIDENCE" -eq "low"]; then
        echo "CONFIDENCE low🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_confidence = '-i'
    elif ["$INPUT_CONFIDENCE" -eq "medium"]; then
        echo "CONFIDENCE medium🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_confidence = '-ii'
    else
        echo "CONFIDENCE high🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_confidence = '-iii'
    fi
fi
 echo "🔥🔥🔥🔥🔥Level = $security_level🔥🔥🔥🔥🔥🔥"
  echo "🔥🔥🔥🔥🔥Confidence = $security_confidence🔥🔥🔥🔥🔥🔥"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv virtualenv $INPUT_PYTHON_VERSION venv
pyenv activate venv

echo "🔥🔥🔥🔥🔥Running security check🔥🔥🔥🔥🔥🔥"
pip install bandit
mkdir -p $GITHUB_WORKSPACE/output
touch $GITHUB_WORKSPACE/output/security_report.txt
echo "🔥🔥🔥🔥🔥$level🔥🔥🔥🔥🔥🔥"
bandit -r $INPUT_PROJECT_PATH -lll -iii -o $GITHUB_WORKSPACE/output/security_report.txt -f 'txt'

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
