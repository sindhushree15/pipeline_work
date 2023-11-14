#!/bin/sh -l
# `$#` expands to the number of arguments and `$@` expands to the supplied `args`
pyenv $securitylevel= 'sindhu'
pyenv $TEMP = "Hello"
printf '%d args:' "$#"
printf " '%s'" "$@"
printf '\n'

echo "🔥🔥🔥🔥🔥$securitylevel🔥🔥🔥🔥🔥🔥"
echo "🔥🔥🔥🔥🔥$TEMP🔥🔥🔥🔥🔥🔥"

$global:security_confidence = ""
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
        echo "If LEVEl low🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_level = "-l"
    elif ["$INPUT_LEVEL" -eq "medium"]; then
        echo "If LEVEl medium🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_level = "-ll"
    else
        echo "If LEVEl high🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $security_level = "-lll"
    fi
fi 

if [ -z "$INPUT_CONFIDENCE" ]; then
    echo "🔥🔥🔥🔥🔥No level provided🔥🔥🔥🔥🔥🔥"
else
    if ["$INPUT_CONFIDENCE" -eq "low"]; then
        echo "If CONFIDENCE low🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $global:security_confidence = "-i"
    elif ["$INPUT_CONFIDENCE" -eq "medium"]; then
        echo "If CONFIDENCE medium🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $global:security_confidence = "-ii"
    else
        echo "If CONFIDENCE high🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"
        $global:security_confidence = "-iii"
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

#bandit -r $INPUT_PROJECT_PATH $INPUT_LEVEL $INPUT_CONFIDENCE -o $GITHUB_WORKSPACE/output/security_report.txt -f 'txt'
bandit -r $INPUT_PROJECT_PATH $INPUT_LEVEL $INPUT_CONFIDENCE -o $GITHUB_WORKSPACE/output/security_report.txt -f json 

if [ $? -eq 0 ]; then
    echo "🔥🔥🔥🔥Security check passed🔥🔥🔥🔥"
    echo $GITHUB_WORKSPACE/output/security_report.txt >> $GITHUB_OUTPUT
else
    echo "🔥🔥🔥🔥Security check failed🔥🔥🔥🔥"
    cat $GITHUB_WORKSPACE/output/security_report.txt >> $GITHUB_OUTPUT
    if $INPUT_IGNORE_FAILURE; then
        exit 0
    else
        exit 1
    fi
fi
