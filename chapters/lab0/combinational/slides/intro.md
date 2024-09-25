# TEMPLATE LECTURE

---

### Included slides

These slides have been included from the `intro.md` file.
They also contain a list as follows:
* item 1
* item 2

----

### Slides including images

![CPU Internals](media/cpu-internals.jpg)

* A slide can also include images included using `![CPU Internals](../media/cpu-internals.jpg)`

----

### All Processes in a System

```
student@os:~$ ps -e | wc -l
32

student@os:~$ ps -e
  PID TTY          TIME CMD
    1 ?        00:00:00 init
  914 ?        00:00:00 init
 2582 ?        00:00:07 gpg-agent
19812 ?        00:00:00 init
19813 ?        00:00:00 init
19814 pts/0    00:00:00 bash
20650 ?        00:00:00 init
20651 ?        00:00:00 init
20652 pts/1    00:00:00 sh
20653 pts/1    00:00:00 sh
20658 pts/1    00:00:00 sh
20661 pts/1    00:00:03 node
20672 ?        00:00:00 init
20673 ?        00:00:00 init
20674 pts/2    00:00:00 node
20681 pts/1    00:00:00 node
20701 ?        00:00:00 init
20702 ?        00:00:00 init
20703 pts/3    00:00:01 node
20722 pts/1    00:00:00 node
20733 pts/1    00:00:18 node
20796 pts/1    00:00:25 node
20915 ?        00:00:00 init
20916 ?        00:00:00 init
20917 pts/4    00:00:00 bash
20964 pts/4    00:00:00 python3
20981 ?        00:00:00 init
20982 ?        00:00:00 init
20983 pts/5    00:00:00 bash
21045 pts/5    00:00:00 ps
```

Terminal listings work the same as in regular markdown files.
