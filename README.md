# pipeline_work

<h5>Step1 : Create workflow either using command line or Git UI under actions option </h5><br>
        > Provide workflow name<br>
        > Update yaml script to run the task<br>
        > save/commit changes<br>
<h5>Step2: Check created workflows under actions<br></h5>
        > You can see the runs under actions once workflow has setup <br>
        > Click any of the run to see the logs<br>
<h5>Step3: Clone repo in destination loc</h5><br>
        > apply some changes and push the build to repo<br>
        > come back and check the running workflows for the logs<br>
        > Push will be completed once the workflow run is completed<br><br>


<h5>About Actions used :</h5><br>
Checkout<br>
Python installtion<br>
Black<br>
mypy<br>
Bandit<br>
isort<br>
Required status check "python_ci (3.7)" is expected
