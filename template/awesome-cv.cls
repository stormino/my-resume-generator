%-------------------------------------------------------------------------------
% awesome-cv.cls
% Based on Awesome-CV by Claud D. Park
%-------------------------------------------------------------------------------

\ProvidesClass{awesome-cv}[2024 Awesome CV Class]
\NeedsTeXFormat{LaTeX2e}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

%-------------------------------------------------------------------------------
% Packages
%-------------------------------------------------------------------------------
\RequirePackage{geometry}
\RequirePackage{xcolor}
\RequirePackage{fontspec}
\RequirePackage{unicode-math}
\RequirePackage{fontawesome5}
\RequirePackage{parskip}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{hyperref}
\RequirePackage{etoolbox}
\RequirePackage{tabularx}
\RequirePackage{calc}
\RequirePackage{needspace}

%-------------------------------------------------------------------------------
% Colors
%-------------------------------------------------------------------------------
\definecolor{awesome-emerald}{HTML}{00A388}
\definecolor{awesome-skyblue}{HTML}{0395DE}
\definecolor{awesome-red}{HTML}{DC3522}
\definecolor{awesome-pink}{HTML}{EF4089}
\definecolor{awesome-orange}{HTML}{FF6138}
\definecolor{awesome-nephritis}{HTML}{27AE60}
\definecolor{awesome-concrete}{HTML}{95A5A6}
\definecolor{awesome-darknight}{HTML}{131A28}
\definecolor{text}{HTML}{333333}
\definecolor{graytext}{HTML}{5D5D5D}
\definecolor{lighttext}{HTML}{999999}

\colorlet{awesome}{awesome-skyblue}

%-------------------------------------------------------------------------------
% Fonts
%-------------------------------------------------------------------------------
\defaultfontfeatures{Ligatures=TeX}
\setmainfont{CrimsonText}[
  Path = /usr/share/fonts/truetype/crimson-text/,
  Extension = .ttf,
  UprightFont = *-Regular,
  ItalicFont = *-Italic,
  BoldFont = *-Bold,
  BoldItalicFont = *-BoldItalic
]

%-------------------------------------------------------------------------------
% Hyperlinks
%-------------------------------------------------------------------------------
\hypersetup{
  colorlinks=true,
  linkcolor=awesome,
  citecolor=awesome,
  filecolor=awesome,
  urlcolor=awesome,
  bookmarks=true,
  bookmarksnumbered=true,
  pdfstartview={FitH}
}

%-------------------------------------------------------------------------------
% Section Styling
%-------------------------------------------------------------------------------
\newcommand{\sectionstyle}[1]{{\fontsize{18pt}{1em}\bfseries\color{awesome} #1}}

\titleformat{\section}
  {\sectionstyle}
  {}{0em}
  {}
  [\vspace{-1ex}\color{awesome}{\rule{\textwidth}{2pt}}]

\titlespacing{\section}{0pt}{4ex}{3ex}

% Define \cvsection command for better section highlighting
\newcommand{\cvsection}[1]{
  \vspace{2mm}
  \section{#1}
}

%-------------------------------------------------------------------------------
% Personal Information Commands
%-------------------------------------------------------------------------------
\newcommand*{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\position}[1]{\def\@position{#1}}
\newcommand*{\address}[1]{\def\@address{#1}}
\newcommand*{\mobile}[1]{\def\@mobile{#1}}
\newcommand*{\email}[1]{\def\@email{#1}}
\newcommand*{\homepage}[1]{\def\@homepage{#1}}
\newcommand*{\github}[1]{\def\@github{#1}}
\newcommand*{\linkedin}[1]{\def\@linkedin{#1}}

%-------------------------------------------------------------------------------
% CV Header
%-------------------------------------------------------------------------------
\newcommand{\makecvheader}{
  \begin{center}
    {\fontsize{32pt}{1em}\bfseries\color{text} \@firstname\ \@lastname}
    
    \vspace{0.4em}
    
    {\fontsize{12pt}{1em}\color{awesome}\@position}
    
    \vspace{0.8em}
    
    {\color{graytext}\small
      \ifdef{\@address}{\mbox{\faIcon{map-marker-alt}\ \@address} \quad}{}
      \ifdef{\@mobile}{\mbox{\faIcon{mobile-alt}\ \@mobile} \quad}{}
      \ifdef{\@email}{\mbox{\faIcon{envelope}\ \href{mailto:\@email}{\@email}} \quad}{}
      \ifdef{\@homepage}{\mbox{\faIcon{globe}\ \href{\@homepage}{\@homepage}} \quad}{}
      \ifdef{\@linkedin}{\mbox{\faIcon{linkedin}\ \href{https://linkedin.com/in/\@linkedin}{\@linkedin}} \quad}{}
      \ifdef{\@github}{\mbox{\faIcon{github}\ \href{https://github.com/\@github}{\@github}}}{}
    }
  \end{center}
  \vspace{1em}
}

%-------------------------------------------------------------------------------
% CV Footer
%-------------------------------------------------------------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\newcommand{\footerstyle}[1]{{\fontsize{8pt}{1em}\color{lighttext} #1}}

\newcommand{\makecvfooter}[3]{
  \fancyfoot[L]{\footerstyle{#1}}
  \fancyfoot[C]{\footerstyle{#2}}
  \fancyfoot[R]{\footerstyle{#3}}
}

%-------------------------------------------------------------------------------
% CV Environments
%-------------------------------------------------------------------------------

% Paragraph environment
\newenvironment{cvparagraph}{
  \vspace{-2.0mm}
  \color{graytext}
  \par
}{
  \par
}

% Entries environment
\newenvironment{cventries}{
  \begin{list}{}{
    \setlength{\leftmargin}{0mm}
    \setlength{\itemindent}{0mm}
    \setlength{\parsep}{0mm}
    \setlength{\itemsep}{3mm}
  }
}{
  \end{list}
}

% Entry with long description
\newcommand{\cventrylong}[6]{
  \needspace{8\baselineskip}
  \item
    \begin{samepage}
    \begin{tabularx}{\textwidth}{@{}X@{\hspace{1em}}r@{}}
      {\color{text}\textbf{#1}} & {\color{awesome}#4} \\
      {\color{graytext}\textit{#2}} & {\color{graytext}\small #3} \\
    \end{tabularx}
    \ifx&#5&\else
      \vspace{1.0mm}
      \color{graytext}
      #5
    \fi
    \ifx&#6&\else
      \vspace{1.5mm}
      {\color{lighttext}\footnotesize\textbf{Technologies:} #6}
    \fi
    \end{samepage}
}

% Simple entry
\newcommand{\cventry}[5]{
  \needspace{6\baselineskip}
  \item
    \begin{samepage}
    \begin{tabularx}{\textwidth}{@{}X@{\hspace{1em}}r@{}}
      {\color{text}\textbf{#1}} & {\color{awesome}#4} \\
      {\color{graytext}\textit{#2}} & {\color{graytext}\small #3} \\
    \end{tabularx}
    \ifx&#5&\else
      \vspace{1.0mm}
      \color{graytext}
      #5
    \fi
    \end{samepage}
}

% Items environment for highlights
\newenvironment{cvitems}{
  \vspace{1.0mm}
  \begin{itemize}[leftmargin=2ex, nosep, itemsep=1mm]
  \setlength{\parskip}{0pt}
  \renewcommand{\labelitemi}{\color{awesome}\textbullet}
  \color{graytext}\small
}{
  \end{itemize}
}

% Skills entries environment
\newenvironment{cvskillentries}{
  \vspace{-2.0mm}
  \begin{list}{}{
    \setlength{\leftmargin}{0mm}
    \setlength{\itemindent}{0mm}
    \setlength{\parsep}{0mm}
    \setlength{\itemsep}{2mm}
  }
}{
  \end{list}
}

% Skills entry
\newcommand{\cvskills}[2]{
  \item
    \begin{tabularx}{\textwidth}{@{}p{4.5cm}@{\hspace{0.5em}}X@{}}
      {\color{text}\textbf{#1}} & {\color{graytext}\small #2}
    \end{tabularx}
}

%-------------------------------------------------------------------------------