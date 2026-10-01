# Moodle setup

1. Upload everything from the `execution/` folder to Moodle under **Execution files**.
2. Upload everything from the `required/` folder (`lut.v` and `test_lut.v`) to Moodle under **Requested files**.
3. Set the maximum number of files to match the number of requested files, which is `2` here: **Settings** → **Submission restrictions** → **Maximum number of files**.
4. Under **Files to keep when running**, select `generate.py`, `task.py` and `variation.sh`. Without these, **Run** can't show the personalized task, because VPL deletes the other execution files before running.