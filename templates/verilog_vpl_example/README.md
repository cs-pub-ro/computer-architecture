# Moodle VPL student variation template and tester

## Directory structure:
assignment-name/
├──ASSIGNMENT.md - The markdown file that contains the assignment text that will be set on moodle
├──res/ - the resources that will be used within the assignment, for example images, graphviz, mermaid diagrams etc (not mandatory)
├──execution/ - the folder with the vpl scripts and helpers
│  ├──vpl_evaluate.sh - the vpl script that will be used to evaluate the student's solution
├──required/  - the folder with the required files
├──submission/ - the folder emulating the moodle submission. Modify this folder when you are trying to test a solution. Automatically generated on first evaluate
├──evaluate.sh - the vpl pipeline simulation script

## Usage
You may use ./evaluate.sh to emulate the VPL pipeline like this:
```bash
./evaluate.sh
```
or with student id:
```bash
STUDENT_ID=6969 ./evaluate.sh
```

On the first evaluate, the folder `submission/` will be created with the required files inside. Any modification to the files inside submission folder will be then used for the validation. Do not modify the files in required/ when testing solutions, this folder should only change when there is a need to change the initial structure given to the student.

If by any chance you want to start fresh, `rm -rf submission`

