# Moodle setup (personalized exercise)

1. Upload everything from the `execution/` folder to Moodle under **Execution files**.
2. Upload everything from the `requested/` folder (`comp1.v`) to Moodle under **Requested files**.
3. Set the maximum number of files to match the number of requested files, which is `1` here: **Settings** -> **Submission restrictions** -> **Maximum number of files**.
4. **Files to keep when running**: select `task.py`, `generate.py` and `variation.sh`. Without them **Run** only shows a note that the setup is incomplete.
5. The statement is personalized: edit its text only in `execution/task.py` (it is printed by Run and Evaluate); `ASSIGNMENT.md` is the generic description for the activity page.
6. Right before the assignment is sent, change `SECRET` in `execution/variation.sh`. Use the same value in all personalized activities and do not change it afterwards (the student's values depend on it).
7. To see the values of a student locally: `python3 execution/generate.py <hash> dump`, where `<hash>` comes from `generate_variation` in `variation.sh`.
