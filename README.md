A set of XSL files to convert the XML output of [forester](https://www.jonmsterling.com/jms-005P.xml) to LaTeX.

On linux, you can use `xsltproc` to execute these files. For example:

```bash
xsltproc -o main.tex forester-to-latex/book.xsl path/to/your/forest/output/index.xml
```

This will produce `main.tex` in the current directory.
Do be warned that compiling this file with `latex` may produce a huge amount of noise in the current directory, as each latex figure in your tree gets a standalone file.

The original version of these files were made by [Jon Sterling](https://www.jonmsterling.com/index.xml). This version contains some edits made by [Eigil Rischel](https://erischel.com).

Most notably I have changed the behaviour of the forester `\ref{}` command. It now outputs `\cite{}` when the linked tree has the `reference` taxon - this is to facilitate writing like this: "See for example [5] for a survey of these results". This can now be produced by the forester code `See for example \ref{lastname-survey-1999} for a survey of these results`.