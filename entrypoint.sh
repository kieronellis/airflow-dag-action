#!/bin/sh

echo "Start Testing"
echo "Requirements path : $1"
echo "DAGs directory : $2"
echo "Variable path : $3"

pip install -r $1

airflow db init
airflow variables import $3

cp -r /action/* /github/workspace/

python -m pytest dag_validation.py -s -q >> result.log
my_var=`echo Pytest exited $?`
python alert.py --log_filename=result.log --repo_token=$4
if [ "$my_var" != "Pytest exited 0" ]; then echo "Pytest did not exit 0" ;fi
if [ "$my_var" != "Pytest exited 0" ]; then exit 1 ;fi