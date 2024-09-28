# Computer Architecture Course Repository

These are open educational resources ([OER](https://en.wikipedia.org/wiki/Open_educational_resources)).
The repository is used for Computer Architecture Course.

## Using the Content

Content is located in the `chapters/` folder.

Each chapter has its own folder.

Lecture content is expected to be presented and followed.
Practice content is expected to be used hands-on individually or as part of team.

## Running Locally

When testing locally, you will have to build the container that will run the builder based on the [`Dockerfile`](Dockerfile).
For this, the simplest way is the use the [`Makefile`](Makefile).
First, edit the `Makefile` and update the `REPO_NAME` variable to the preferred name of your future website.

To generate the web contents locally, run:

```console
make
```

To view the local contents, start a web server by running the command:

```console
make serve
```

As the output of the command tells, point your browser to `http://localhost:8080/$REPO_NAME`, where `$REPO_NAME` is the name of the repository you configured in the [`Makefile`](Makefile)..

## Chapter Contents

### Lecture

Slides are written in [GitHub Markdown](https://guides.github.com/features/mastering-markdown/) and use [reveal-md](https://github.com/webpro/reveal-md) and [reveal.js](https://revealjs.com/) to render HTML output.
Building slides requires [MarkdownPP](https://github.com/amyreese/markdown-pp).
Lecture slides are built from the `slides.mdpp` file using the `make` command (and the `Makefile`).
`slides.mdpp` is a wrapper / index file;
actual content is stored in Markdown format in files in the `slides/` subfolder.
Output is generated in the `_site/` subfolder;
open the `_site/index.html` in a browser to view the slides.

Demos are snippets of code and support files that showcase concepts and ideas related to the lecture.
Demos are located in the `demo/` subfolder.
Each demo has its own folder with source code, `Makefile` or other build files (if required) and support files.

Media files are images and films used in slides for visual support.
Media files are located in the `media/` subfolder.

Quizzes are used in slides to trigger interactivity with participants and as a form of (self-)assessment.
Quizzes are located in the `quiz/` subfolder.
Quiz questions are stored in [Markdown format](https://guides.github.com/features/mastering-markdown/), one file per quiz.

### Practice

Practice content consists of background text, media files, support files and quizzes in the `practice/` subfolder of each chapter.

Background text is located in `chapters/` folder as a series of sections.
Each section consists of general information, tutorial information followed by description of actual work items and a quiz.
Sections are indexed in the `README.md` file.

Support files for work items are stored in the `support/` subfolder.
There is a subfolder for each section.
Each section subfolder contains source code, `Makefile` (or other build files, if required) and support files.

Media files are images and films used in text for visual support.
Media files are located in the `media/` subfolder.

Quizzes are referenced at the end of each section as a form of (self-)assessment.
Quizzes are located in the `quiz/` subfolder.
Quiz questions are stored in [Markdown format](https://guides.github.com/features/mastering-markdown/), one file per quiz.

## Contributing

Contributions are welcome.
See the [contribution guide](CONTRIBUTING.md) on how you could report or fix issues and on how you can improve the content.

Reviewers are requested to follow the [reviewing guide](REVIEWING.md)
