## Slides hierarchy

---

## Slides Hierarchy

* Slides are organized in two levels
    * We use `---` in order to open up a new topic.
       This leads to a new horizontal slide figuring a topic that can be expanded by vertical slides.
    * We expand discussions on the same topic by vertical slides.
       We use `----`, which adds a new vertical slide

----

### New Vertical Slide

* This slide illustrates a new item of discussion on the matter of the slides hierarchy

---

### Animated Slides

* You can even animate slides like this

``` [1 - 2 | 3 - 4]
student@os:~/.../compute/lecture/demo/create-process$ strace -e clone ./fork_exec
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f7e83aa4810) = 5302
student@os:~/.../compute/lecture/demo/create-thread$ strace -e clone ./create_thread
clone(child_stack=0x7f9ea7df0fb0, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID, tls=0x7f9ea7df1700, child_tidptr=0x7f9ea7df19d0) = 5389
```

---

### Tables

You can include tables:

| Advantages                       | Disadvantages                              |
| :------------------------------: | :----------------------------------------: |
| implemented by libraries         | implemented by the kernel                  |
| blocking actions stall process   | blocking actions only stall current thread |
| more mapped on one kernel thread | provide support for user level threads     |
| Java, Python                     | Linux KThreads, Windows threads            |
