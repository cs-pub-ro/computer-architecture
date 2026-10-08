# Moodle setup

1. Upload everything from the `execution/` folder to Moodle under **Execution files**.
2. Upload everything from the `requested/` folder (`generic_adder.v`, `generic_adder_test.v`) to Moodle under **Requested files**.
3. Set the maximum number of files to match the number of requested files, which is `2` here: **Settings** -> **Submission restrictions** -> **Maximum number of files**.
4. **Files to keep when running**: select `task.py` (it prints the assignment in the console; without it **Run** shows a note instead of the text).
5. Edit the assignment text only in `execution/task.py`. `ASSIGNMENT.md` is a copy for the activity description (refresh it with `python3 execution/task.py > ASSIGNMENT.md`).
6. Right before the assignment is sent, change `SECRET` in `execution/variation.sh`.
