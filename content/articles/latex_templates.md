# LaTeX Templates

I was recently looking for some instructions about templates for a presentation
written using the [Beamer](https://en.wikipedia.org/wiki/Beamer_%28LaTeX%29)
document class in LaTeX.

The aim of this page is to collect some instructions and a few bits I learned
during the process. I also plan to keep this page updated with stuff about LaTeX
in general (hopefully).

## Guides

Firs off some useful guides:

* [Beamer Theme Matrix](https://www.hartwork.org/beamer-theme-matrix/) <br>
	For choosing a base theme and its variant.
* [Better Beamer Themes](http://hamaluik.com/posts/better-beamer-themes/) <br>
	For some basic instructions on creating a theme.

## Boilerplate code

Now some boilerplate code for a presentation:

	\documentclass[a4paper]{beamer}
	\usetheme{%%yourtheme}

	\usepackage{mathtools}
	\usepackage{lmodern}

	\title{The Title}
	\author{Author}
	\date{\today}

	\begin{document}
	%
	%% title frame
	\begin{frame}
		\maketitle
	\end{frame}

	\begin{frame}{Another frame, with title}
		Content
	\end{frame}

	%
	%% The last frame is the same as the first one
	\begin{frame}
		\maketitle
	\end{frame}
	\end{document}

Also some code for an article:

	TODO

## Custom University of Padova Theme

During my PhD at the University of Padova I often need some theme for a
presentation.

A good one can be found
[here](https://andrea.burattin.net/stuff/tema-latex-beamer-padova/).
I used this theme as a starting point to create my own variation.

	TODO
