# Lab Handouts

We build one A4 PDF for each lab from 0 through 11.
The topic order follows `Laboratoare` in [config.yaml](../config.yaml), without the website's intermediate "Teorie" heading.
The PDFs use a shared document template, not the course slide presentation theme.
We retain each material's existing language.

## Requirements

We use Typst 0.15.1, Make, and Python 3 for the integrity checker.
The repository's development container provides these tools and the required Liberation Serif and DejaVu Sans Mono fonts.
Outside the container, we install these fonts on the machine running the compiler or Tinymist.
We do not need LaTeX, Pandoc, or the separate thesis-template repository.

## Generate PDFs

From the `computer-architecture` repository root, we run:

```sh
make -C labs
```

The output is `labs/build/lab-0.pdf` through `labs/build/lab-11.pdf`.
To rebuild only lab 1, we run:

```sh
make -C labs build/lab-1.pdf
```

The Makefile always rebuilds requested PDFs, including when only an included topic or image changed.
The generated `build/` directory is ignored by Git; we commit sources, not PDFs.
We remove generated outputs with:

```sh
make -C labs clean
```

To select a different compiler executable for PDF builds, we can pass `TYPST=/path/to/typst` to Make.
The integrity checker separately invokes `typst` from `PATH`.

### Compile or Watch Directly

From the repository root, we can use the same compilation boundary as the Makefile:

```sh
mkdir -p labs/build
typst compile --root . labs/1/main.typ labs/build/lab-1.pdf
typst watch --root . labs/1/main.typ labs/build/lab-1.pdf
```

We stop `typst watch` with Ctrl+C.
The project root must be the repository root, not `labs/` or a topic's `reading/` directory.
Otherwise, imports and media outside that directory may be inaccessible.

## Preview with Tinymist in VS Code

1. We install or enable **Tinymist Typst** (`myriad-dreamin.tinymist`) in the environment where the repository is open, including the remote development container when applicable.
2. We open the complete repository in VS Code and open the lab entry point, for example [1/main.typ](1/main.typ).
3. We search the Command Palette for **Typst Preview: Preview Opened File**, or use **Typst Preview: Preview Opened File in Browser**.
4. Before switching to an included topic, we run **Pin the Main File to the Currently Open Document** while the lab entry point is active.
   The pinned entry point keeps the full lab template and topic sequence active while we edit included files.
5. When switching labs, we run **Unpin the main file**, open the new lab entry point, and pin it again.

We use the document preview, not slide mode.
An individual topic is reusable content rather than a complete handout, so previewing it alone does not apply the lab layout.
Tinymist updates the preview as we edit, but release PDFs still come from the Makefile.

If Tinymist reports inaccessible files or cannot resolve `/labs/common/template.typ`, we set **Tinymist: Root Path** to the absolute repository path in workspace settings.
In this development container, the setting is:

```json
{
  "tinymist.rootPath": "/workspace/computer-architecture"
}
```

For another checkout location, we use that checkout's absolute path instead.
We merge the setting into existing workspace settings rather than replacing them.
If preview fonts differ from the command-line PDF, we check fonts in the environment running Tinymist and configure `tinymist.fontPaths` if necessary.

## Source Organization

- Numbered `main.typ` files select the lab title, number, and ordered topic includes.
- [common/config.typ](common/config.typ) defines the handout language, fonts, institution names, and logos.
  Course name, lecturer, and academic year are imported from [slides/common/config.typ](../slides/common/config.typ); changing that metadata also affects course slides.
- [common/template.typ](common/template.typ) provides the A4 layout, captions, code sizing, and callouts.
- Reusable topics live beside the website Markdown, for example [the Verilog topic](../chapters/verilog/basic/reading/README.typ) beside [its Markdown source](../chapters/verilog/basic/reading/README.md).
- Topic images stay in their existing sibling `media/` directories.

## Maintaining Materials

We update both the Markdown and Typst versions when changing educational content.
They are separate sources; builds do not convert or synchronize Markdown automatically.
We preserve code examples, formulas, table cells, captions, links, and the existing language when making formatting-only changes.

Topics contain their own heading hierarchy: `=` for the topic, `==` for sections, and `===` for subsections.
We do not duplicate the topic heading in the lab entry point or add lab-specific page settings to a reusable topic.
For a new topic or changed lab order, we update the relevant entry point, the website mapping in [config.yaml](../config.yaml), and `LABS` / `LAB_TITLES` in [check.py](check.py).
The checker uses an explicit reference mapping; it does not parse the website config dynamically.
The Makefile automatically discovers one- and two-digit lab directories containing a `main.typ` file.

### Typst Details

- Relative paths resolve from the file containing the `image`, `read`, or `include` call.
  We load topic media inside the topic using paths such as `../media/image.png`; the repository-wide root only sets the access boundary.
- Website image suffixes such as `?200` are sizing hints, not part of a filesystem filename.
  We express image sizing through Typst arguments and preserve the original aspect ratio.
- We use raw code fences or `raw(...)` for Verilog directives, `$monitor`, delays, and bit literals so Typst does not interpret them as markup or math.
- Typst math uses a single-dollar delimiter pair, including for display equations.
  A single backslash creates a math line break; LaTeX's paired backslashes do not.
  Multi-letter notation needs quotes when it is text rather than a defined math variable.
- We replace HTML wrappers and website callouts with native figures, tables, subscripts, and the shared `callout` helper.
- Supplementary files outside a standalone PDF need usable links.
  Lab 10 links to its existing supplementary PDFs through the repository's HTTPS URLs instead of nonexistent files next to the generated handout.
- Wide code is fitted to the available width, and tables can span pages with repeated headers.
  We inspect readability rather than assuming compilation proves the layout is suitable.

## Checks Before Review

From the repository root, we run:

```sh
make -C labs check
make -C labs
git diff --check
```

The checker verifies configured lab titles and required topic include order, topic titles, ordered image references and image existence, table counts, and preservation of fenced Markdown code in the compiled Typst document.
It does not prove that all prose, formulas, table-cell values, link destinations, or page layouts are equivalent.
We also compare changed materials with the Markdown and inspect the generated PDF, especially long listings, wide tables, captions, and Romanian diacritics.
Git's diff checks do not include untracked files, so we review newly added sources as well.

For a targeted visual check, we can render selected pages without installing a separate PDF rasterizer:

```sh
typst compile --root . --pages 1,2 labs/1/main.typ '/tmp/lab-1-{p}.png'
```

These commands do not publish PDFs to the website.
The existing Docusaurus build still uses the Markdown materials; PDF publication or a future single-source workflow requires separate integration.