
% Identification
% ==============
\NeedsTeXFormat{LaTeX2e}

\newcommand\@classname    {utmthesis}
\newcommand\@classabout   {Class File for Universiti Teknologi Malaysia Thesis Writing}
\newcommand\@classdate    {2021/05/02}
\newcommand\@classversion {v6.4}  
\ProvidesClass{\@classname}[\@classdate\space\@classversion\space\@classabout]

\RequirePackage{ifplatform}
\RequirePackage{acronym}
\RequirePackage{emptypage}
\RequirePackage{newtxtext,newtxmath}
\RequirePackage[hidelinks]{hyperref} 
\pdfstringdefDisableCommands{%
\let\MakeUppercase\relax
}
\let\maketitle\relax
\let\appendix\relax

% Initial code
% ============
\newcommand{\@initializeThesisAsEnglish}{
  \def\utmthesis@language{en}
  \def\abstract@filename{abstract}
  \def\abstract@translated@filename{abstrak}
}

% Returns (english/malay) externalized string according to \utmthesis@language
% E.g. if \def\utmthesis@language{en} is set,
%      then \getstring{chaptername} calls \chaptername@en
%
\newcommand{\getstring}[1]{\csname #1@\utmthesis@language \endcsname}

% Declaration of options
% ======================
\DeclareOption{oneside}{\PassOptionsToClass{oneside}{book}}
\DeclareOption{final}{\PassOptionsToClass{final}{book}}
\DeclareOption{draft}{\PassOptionsToClass{draft}{book}}
\DeclareOption{english}{\@initializeThesisAsEnglish}

\DeclareOption*{%
  \ClassWarning{\@classname}{Unknown option `\CurrentOption'}%
}

% Execution of options
% ====================
\ExecuteOptions{final,english}% the default settings
\ProcessOptions

% Package loading
% ===============

% Already met by default (in book.cls or LaTeXe2 itself)
%
% [A5] Page number style (frontmatter): small-letter Roman (i,ii,iii,..)
% [A6] Page number style (mainmatter): Arabic (1,2,3,..)
% [B2] If heading is more than 1 line, same line spacing in text should be used
% [B5] Appendix can be named, e.g. Appendix A. Specific title can also be given
% [C1] Use same font type throughout thesis
% [D9] 2-character spacing after a full-stop (.)
% [D10] 1-character spacing after a comma (,)
% [D14] New chapter must start with a new page
% [E3] Caption is Arabic-numbered respect to chapter number
% [E4] If caption is single line, aligned to center
% [E5] If caption is multi-line, aligned to left
% ----------------------------------------------------------------------

% Must do-it-yourself when writing the thesis text:
%
% [B3] Subsection headings beyond level 4 (\subsubsection) should be labeled
%      with characters.
% [C4] Chapter title (UPPERCASE)
% [C6] Write quotation in a separate paragraph
% [C7] If quotation is in different language, use italic
% [E1] Caption is positioned at the top of table
% [E2] Caption is positioned at the bottom of figure
% [E6] Table/figure should be positioned after being cited for the 1st time
% [E7] Tables/figures in a chapter can also be grouped together
% ----------------------------------------------------------------------


% [A1] A4 size (210 x 297mm)
% [A2] Printed on one side
% [C2] Preferred font type: Time News Roman, size: 12 or bigger
% [C3] Character size
%      (CAPITAL LETTER not less than 0.2cm, small-letter not less than 0.15cm)
% ---------------------------------------------------------

%default twoside printing
\LoadClass[a4paper,12pt,onecolumn]{book}

% To allow ToC level changes
\RequirePackage{tocvsec2}

% To meet [D1], we use \setstretch{1.435} command provided by 'setspace' package.
% In addition, this package fixes common line-spacing issues (e.g. too-large
% line-spacing in footnote) that happens when line-spacing is modified.
\RequirePackage{setspace}

% To meet [D7], we increase \parskip to non-zero height,
% but this will cause unexpected extra spacing problems (e.g in environment).
% The 'parskip' package is known to fix these problems.
\RequirePackage{parskip}

% Needed for optional list of algorithms
\RequirePackage{algorithm}
\RequirePackage{enumitem}
\setlist{leftmargin=0.5in}

\RequirePackage[final]{pdfpages}

% Set to no widow lines 
\RequirePackage[all]{nowidow}
\raggedbottom

% [A3] Page margin (left/right: 3.25cm, top/bottom: 2.5cm)
\RequirePackage[top=2.5cm,left=3.25cm,right=3.25cm,bottom=2.5cm]{geometry}

% Define an if@appendix flags, to be used in \chapter
% to switch formatting between chapter/appendix title.
% When \appendix is called, the flag is set to TRUE.
\newif\if@appendix% to check if appendix is used
\@appendixfalse%  initially set to FALSE
\newif\if@appendixtoc % to check if appendix page number is being printed in ToC
\@appendixtocfalse%  initially set to FALSE

\newcommand\ext@appendix{loapp}

% +++++++++++++++++++++
% Externalized string  - Caption labels
% +++++++++++++++++++++
% -- English
\newcommand{\tablename@en}		{Table}
\newcommand{\figurename@en}		{Figure}
\newcommand{\algorithmname@en}		{Algorithm}
\newcommand{\tablelistname@en}    	{Table}
\newcommand{\figurelistname@en}   	{Figure}
\newcommand{\algorithmlistname@en}	{Algorithm}
% -- Malay
\newcommand{\tablename@ms}    		{Jadual}
\newcommand{\figurename@ms}   		{Rajah}
\newcommand{\algorithmname@ms}		{Algoritma}
\newcommand{\tablelistname@ms}    	{Jadual}
\newcommand{\figurelistname@ms}   	{Rajah}
\newcommand{\algorithmlistname@ms}	{Algoritma}
% --
\renewcommand{\tablename}     		{\getstring{tablename}}
\renewcommand{\figurename}    		{\getstring{figurename}}
\floatname{algorithm}		  	{\getstring{algorithmname}}
\newcommand{\tablelistname}     	{\getstring{tablelistname}}
\newcommand{\figurelistname}    	{\getstring{figurelistname}}
\floatname{algorithmlist}		{\getstring{algorithmlistname}}

% +++++++++++++++++++++
% Externalized string  - Heading labels
% +++++++++++++++++++++
% -- English
\newcommand{\partname@en}     		{PART}
\newcommand{\chaptername@en}  		{CHAPTER}
\newcommand{\appendixname@en} 		{Appendix}
% -- Malay
\newcommand{\partname@ms}     		{BAHAGIAN}
\newcommand{\chaptername@ms}  		{BAB}
\newcommand{\appendixname@ms} 		{Lampiran}
% --
\renewcommand{\partname}      		{\getstring{partname}}
\renewcommand{\chaptername}   		{\getstring{chaptername}}
\renewcommand{\appendixname}  		{\getstring{appendixname}}

% +++++++++++++++++++++
% Externalized string  - Page titles (frontmatter)
% +++++++++++++++++++++
% -- English
\newcommand{\declarationame@en}     {DECLARATION}
\newcommand{\dedicationname@en}     {DEDICATION}
\newcommand{\acknowledgementname@en}{ACKNOWLEDGEMENT}
\newcommand{\abstractname@en}       {ABSTRACT}
\newcommand{\abstractlocalname@en}  {ABSTRAK}
\newcommand{\contentsname@en}       {TABLE OF CONTENTS}
\newcommand{\listtablename@en}      {LIST OF TABLES}
\newcommand{\listfigurename@en}     {LIST OF FIGURES}
\newcommand{\listabbrename@en}      {LIST OF ABBREVIATIONS}
\newcommand{\listsymbolname@en}     {LIST OF SYMBOLS}
\newcommand{\listappendixname@en}   {LIST OF APPENDICES}
\newcommand{\listalgorithmname@en}  {LIST OF ALGORITHMS}
\newcommand{\listpublicationname@en}{LIST OF PUBLICATIONS}
% -- Malay
\newcommand{\declarationame@ms}     {PENGAKUAN}
\newcommand{\dedicationname@ms}     {DEDIKASI}
\newcommand{\acknowledgementname@ms}{PENGHARGAAN}
\newcommand{\abstractname@ms}       {ABSTRACT}
\newcommand{\abstractlocalname@ms}  {ABSTRAK}
\newcommand{\contentsname@ms}       {KANDUNGAN}
\newcommand{\listtablename@ms}      {SENARAI JADUAL}
\newcommand{\listfigurename@ms}     {SENARAI RAJAH}
\newcommand{\listabbrename@ms}      {SENARAI SINGKATAN}
\newcommand{\listsymbolname@ms}     {SENARAI SIMBOL}
\newcommand{\listappendixname@ms}   {SENARAI LAMPIRAN}
\newcommand{\listalgorithmname@ms}  {SENARAI ALGORITHMA}
\newcommand{\listpublicationname@ms}{SENARAI PENERBITAN}
% --
\newcommand{\declarationname}       {\getstring{declarationame}}
\newcommand{\dedicationname}        {\getstring{dedicationname}}
\newcommand{\acknowledgementname}   {\getstring{acknowledgementname}}
\newcommand{\abstractname}          {\getstring{abstractname}}
\newcommand{\abstractlocalname}     {\getstring{abstractlocalname}}
\renewcommand{\contentsname}        {\getstring{contentsname}}
\renewcommand{\listtablename}       {\getstring{listtablename}}
\renewcommand{\listfigurename}      {\getstring{listfigurename}}
\newcommand{\listabbrename}         {\getstring{listabbrename}}
\newcommand{\listsymbolname}        {\getstring{listsymbolname}}
\newcommand{\listappendixname}      {\getstring{listappendixname}}
\renewcommand{\listalgorithmname}   {\getstring{listalgorithmname}}
\newcommand{\listpublicationname}   {\getstring{listpublicationname}}


% +++++++++++++++++++++
% Externalized string  - Page titles (mainmatter)
% +++++++++++++++++++++
% -- English
\newcommand{\bibname@en}        {REFERENCES}
\newcommand{\appendicesname@en} {Appendices}
% -- Malay
\newcommand{\bibname@ms}        {RUJUKAN}
\newcommand{\appendicesname@ms} {Lampiran}
% --
\renewcommand{\bibname}         {\getstring{bibname}}
\newcommand{\appendicesname}    {\getstring{appendicesname}}%  used once in TOC


% ==========================
%  Line Spacing Formatting
% --------------------------

% Define 2 parameters: one-line, two-line spacing (single-spacing line)
\newlength{\@onelinespacing}
\setlength{\@onelinespacing}{0.8\baselineskip}%  remove the 20% extra spacing
                                              %  added by LaTeX, hence 0.8
\newlength{\@twolinespacing}
\setlength{\@twolinespacing}{2\@onelinespacing}


% [D7] 2-line spacing between text paragraphs
% -------------------------------------------
%
% Copied from parskip.sty:
%   \parskip  - defines spacing between paragraphs
%   \parsep   - more specifically: \@listI, \@listii, \@listiii
%               \parsep defines spacing between items in list environment

% modify \parskip to use \@twolinespacing
\parskip=\@twolinespacing \advance\parskip by 0pt plus 2pt

% modify \parsep to .5\@onelinespacing
\def\@listI{\leftmargin\leftmargini
   \topsep\z@ \parsep .5\@onelinespacing \itemsep\z@}
\let\@listi\@listI
\@listi

\def\@listii{\leftmargin\leftmarginii
   \labelwidth\leftmarginii\advance\labelwidth-\labelsep
   \topsep\z@ \parsep .5\@onelinespacing \itemsep\z@}

\def\@listiii{\leftmargin\leftmarginiii
    \labelwidth\leftmarginiii\advance\labelwidth-\labelsep
    \topsep\z@ \parsep .5\@onelinespacing \itemsep\z@}


% [D12] The 1st line in paragraph left-indent 0.5 inch (1.27cm)
% -------------------------------------------------------------
%
% By default, the 1st line of 1st paragraph after heading is not indented.
% To meet [D12], we remove this rule.
%
% Copied from 'indentfirst' package, two-line code:
\let\@afterindentfalse\@afterindenttrue
\@afterindenttrue
%
% Then set the indentation length
\setlength{\parindent}{0.5in}


% [D1] 1.5 line spacing
% ---------------------
\setstretch{1.435}


% [D13] Don't start a new text paragraph on the last line of the page
%       (no club-line)
% -----------------------------------------------------------------------------
% don't use 10000, otherwise, you're not giving latex any chance
\clubpenalty=4000%9999     	% avoid club line at bottom of page
\widowpenalty=4000%9999 	% avoid widow line at the top of page
\brokenpenalty=4000%9999	% avoid page break after a hyphenated line

% Note: By default, book.cls allows club/widow/broken line.
% To restore the default behavior, comment the 3 lines above.

% =======================
%  Minimize Hyphenation
% -----------------------
% Note: The default book.cls renders a lot hyphenated words.
% Without \sloppy, text may overflow out the required textwidth.
\hyphenpenalty=4000\sloppy

% ========================
%  Page Style Formatting
% ------------------------
% [A7] Page number in 1st page of preliminary pages is counted, but not printed
% [A8] Page number in 1st page of each chapter is counted, but not printed
% ----------------------------------------------------------------------------

% LaTeX page style options:
% By default, \chapter will switch the current page style to 'plain'.
\newcommand{\@showpagenumber}{\thispagestyle{plain}}
% To hide page number in the current page, call \@hidepagenumber.
\newcommand{\@hidepagenumber}{\thispagestyle{empty}}


% =================
%  TOC Formatting
% -----------------
\RequirePackage[titles]{tocloft}

\def\toclevel@nonmainmatterchapter{0}
\def\toclevel@appendixchapter{1}

% Set the highest heading level to appear in TOC.
\setcounter{tocdepth}{3}

% Hide the dots between line number and heading title.
\renewcommand\@dotsep{10000}% set the separation between dots really big
\renewcommand{\@tocrmarg}{4em}
\renewcommand{\@pnumwidth}{4em}

% Position different heading titles in TOC:
%
% To make position modification easier, we define 2 types of parameters:
%   \toc@tab@n  - the tab position measured from left-margin
%   \toc@sep@n  - the separation size between each tab

\newlength{\toc@tab@a}
\newlength{\toc@tab@b}
\newlength{\toc@tab@c}
\newlength{\toc@tab@jumps}

\newlength{\toc@sep@part}
\newlength{\toc@sep@chap}
\newlength{\toc@sep@figs}
\newlength{\toc@sep@figstitle}
\newlength{\toc@sep@a}
\newlength{\toc@sep@b}
\newlength{\toc@sep@c}
\newlength{\toc@sep@d}

% Their usage is visualized in the picture below:
%
%            |tab@a  |tab@b   |tab@c
% | 6em      | 3em   | 4em    | 4em    |
% | sep@a    | sep@b | sep@c  | sep@d  |
% +----------+-------+--------+--------+
% |   | sep@chap
% +---+
% 1          CHAPTER HEADING
%            1.1     Section Heading
%                    1.1.1    Subsection Heading
%                             1.1.1.1  Subsubsection Heading
%
% | 8em         |
% | sep@part    |
% +-------------+-------
% PART I        PART TITLE
%
% To modify tab positions, only need to adjust \toc@sep@n values:
\setlength{\toc@sep@part}{8em}
\setlength{\toc@sep@chap}{2em}
\setlength{\toc@sep@figs}{0cm}
\setlength{\toc@sep@figstitle}{2.5cm}
\setlength{\toc@sep@a}{7em}
\setlength{\toc@sep@b}{4em}
\setlength{\toc@sep@c}{4em}
\setlength{\toc@sep@d}{4em}

% Table jumps for centering the "TITLE" in all ToCs
\setlength{\toc@tab@jumps}{3.5em}

% \toc@sep@n values will be used in the rest of TOC formatting:

% Set tab positions
\setlength{\toc@tab@a}{\toc@sep@a}
\setlength{\toc@tab@b}{\toc@tab@a} \addtolength{\toc@tab@b}{\toc@sep@b}
\setlength{\toc@tab@c}{\toc@tab@b} \addtolength{\toc@tab@c}{\toc@sep@c}

% LaTeX internal command to arrange TOC entry:
%   \@dottedtocline {heading level}{left indent}{numbering label's width}

% Format section, subsection and subsubsection in TOC
\renewcommand*\l@section{\@dottedtocline{1}{4.5em}{2.45em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{\toc@tab@a}{\toc@sep@b}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{\toc@tab@b}{\toc@sep@c}}


% Format entries in \listoffigures, \listoftables and \listofappendices
\renewcommand{\cftfigdotsep}{\cftnodots}
\renewcommand{\cfttabdotsep}{\cftnodots}
\setlength{\cftfigindent}{0em}
\setlength{\cfttabindent}{0em}
\setlength{\cftfignumwidth}{\toc@sep@a}
\setlength{\cfttabnumwidth}{\toc@sep@a}

%Format caption of tables
\RequirePackage[labelsep=quad,aboveskip=5pt,belowskip=5pt,labelformat=simple]{caption}

\newcommand*\l@appendix{\@dottedtocline{1}{\toc@sep@figs}{\toc@sep@figstitle}}
\newcommand*\l@algorithm{\@dottedtocline{1}{\toc@sep@figs}{\toc@sep@figstitle}}

\renewcommand\cftfigpresnum{\figurelistname~}
\renewcommand\cfttabpresnum{\tablelistname~}

% Copied from book.cls:
%   \l@chapter  - format chapter in TOC
%   \@chapter   - called when there is a numbered chapter
% Main ToC formating
\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \setlength\@tempdima{\toc@sep@a}
    \begingroup
      \parindent -\toc@sep@a 
      \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip  
      \toc@sep@a
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth {\hss #2}\par
      \penalty9999% to discourage chapter to appear at last line of page
    \endgroup
  \fi}


\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
     \if@mainmatter
       \refstepcounter{chapter}%
       \typeout{\@chapapp\space\thechapter.}%
       \if@appendix
         \addcontentsline{\ext@appendix}{appendix}%
                         {\protect\numberline{\appendixname\space\thechapter}{#1}} 
         \@makechapterhead{#2}%
         \@afterheading
       \else
         \addtocontents{toc}{\protect\addvspace{\@twolinespacing}}%
         \addcontentsline{toc}{chapter}{\protect\numberline{\MakeUppercase{\chapter@colname} \thechapter}\MakeUppercase{#1}}%
         \@makechapterhead{\MakeUppercase{#2}}%
         \@afterheading
       \fi
     \else
       \addcontentsline{toc}{nonmainmatterchapter}{\MakeUppercase{#1}}%
     \fi
  \else
    \addcontentsline{toc}{chapter}{\MakeUppercase{#1}}%
  \fi
  \chaptermark{#1}%
  \@showpagenumber
  }


% =====================
%  Heading Formatting
% ---------------------

% [B1] Heading level, not more than 4 levels
%      (chapter, section, subsection, subsubsection)
% --------------------------------------------------------------------
% secnumdepth - the highest heading level to have numbering label.
% Must be executed as late as possible (right before \begin{document})
% to avoid conflict with 'arabtex' package.
%
% Conflict symptoms (with 'arabtex' package):
%   \subsubsection{} does not show its numbering label.
%
\AtBeginDocument {
  \setcounter{secnumdepth}{3}
}

% [A9] The part separation sheets between parts is not be counted nor numbered.
% -----------------------------------------------------------------------------
% Copied from book.cls:
%   \part  -  start a new part in document
%   \@endpart - called at the end of the \part command
%
\renewcommand\part{%
  \if@openright\cleardoublepage\@hidepagenumber\else\clearpage\@hidepagenumber\fi
  \@hidepagenumber%  this page does not have page number
  \if@twocolumn
    \onecolumn
    \@tempswatrue
  \else
    \@tempswafalse
  \fi
  \null\vfil
  \secdef\@part\@spart}

\newcounter{utmthesis@temp@page}% A temporary counter to store page counter

\def\@endpart{%
  \setcounter{utmthesis@temp@page}{\value{page}}% Store current page counter
  \pagenumbering{Roman}% Change number style (implicitly reset page counter)
  \setcounter{page}{\value{part}}% Set page counter to part counter
  \vfil\newpage
  \pagenumbering{arabic}% Restore number style (implicitly reset page counter)
  \setcounter{page}{\value{utmthesis@temp@page}}% Restore page counter
  \if@twoside
    \if@openright
      \null
      \thispagestyle{empty}%
      \newpage
    \fi
  \fi
  \if@tempswa
    \twocolumn
  \fi}

% [B4] The part separation sheet should be printed with capital letters,
%      e.g. PART 1, PART 2, PART 3
% ----------------------------------------------------------------------------
% Similar to \contentsline, but does not accept nor display page number
\newcommand*\nonumcontentsline[1]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{2.25em \@plus\p@}%
    \settowidth{\@tempdima}{\partname~N }
    \ifdim \@tempdima <\toc@sep@a
      \setlength\@tempdima{\toc@sep@a}
    \else
      \setlength\@tempdima{\toc@sep@part}
    \fi
    \begingroup
      \parindent \z@
      {\leavevmode
       \bfseries #1}\par
       \nobreak
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi}

% Copied from book.cls:
%   \@part - format the part title
\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}%
      %  add to TOC, but without page number (since this page is not counted)
      \addtocontents{toc}{\protect
          \nonumcontentsline{\numberline{\partname\space\thepart}\MakeUppercase{#1}}}
    \else
      %  add to TOC, but without page number
      \addtocontents{toc}{\protect\nonumcontentsline{\MakeUppercase{#1}}}
    \fi
    \markboth{}{}%
    {\centering
    \vfill
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >-2\relax
       % part number - UPPERCASE, and make it slightly larger
       \large \bfseries \MakeUppercase{\partname\nobreakspace\thepart}
       \par
       \vskip 20\p@
     \fi
     % part title - make it slightly larger
     \large \bfseries \MakeUppercase{#2}\par}%
     \vfill
    \@endpart}


% [C4] Chapter title (centered, bold)
% [D2] 2.5cm spacing between margin-top & chapter label
% [D3] 4-line spacing between chapter label & chapter title
% [D4] 4-line spacing between chapter title & first line of text paragraph
% -------------------------------------------------------------------

% Define blue color
\usepackage{xcolor}
% \definecolor{chapterblue}{RGB}{0, 102, 204} % adjust as needed
\definecolor{chapterblue}{RGB}{0,51,102}

% Copied from book.cls:
%   \@makechapterhead  - defines \chapter{} formatting
%   \@makeschapterhead - defines \chapter*{} formatting
% Remove numbering for \chapter{}
\renewcommand\@makechapterhead[1]{%
  {\parindent \z@ \raggedright \normalfont \bfseries \color{chapterblue}
    \thechapter\quad #1\par % number + title
    \nointerlineskip
    \rule{\textwidth}{1pt} % line directly under title
    % \nointerlineskip % critical: no vertical skip here!
  }%
}

% For \chapter*{}
\renewcommand\@makeschapterhead[1]{%
  \@hidepagenumber
  {  \parindent \z@ \raggedright \normalfont \bfseries \color{chapterblue}
    \thechapter\quad #1\par % number + title
    \nointerlineskip
    \rule{\textwidth}{1pt} % line directly under title
    % \nointerlineskip % critical: no vertical skip here!
  }%
}

% [C5] Title of (sub)section (bold)
% [D5] 4-line spacing between last line of text & (sub)section heading
% [D6] 2-line spacing between (sub)section heading & first line of text
% [D11] Section heading aligned with margin-left
% -----------------------------------------
% Prepare a tiny skip approx. to 0pt, will be used in {afterskip} below
\newlength{\@tinyskip}
\setlength{\@tinyskip}{0.001mm}



% LaTeX generic command to format section headings:
% \@startsection {name}{level}{left-indent}
%                {beforeskip}
%                {afterskip} % must be positive to prevent run-in heading
%                {styles}
%
\ifwindows 
	\renewcommand\section{\@startsection {section}{1}{0pt}%
	                                     {2\@twolinespacing}%
	                                     {\@twolinespacing}%
	                                     {\normalfont\normalsize\bfseries}}
\else
	\renewcommand\section{\@startsection {section}{1}{0pt}%
	                                     {\@twolinespacing}%
	                                     {\@tinyskip}%
	                                     {\normalfont\normalsize\bfseries}}
\fi

\ifwindows 
	\renewcommand\subsection{\@startsection {subsection}{2}{0pt}%
	                                     {2\@twolinespacing}%
	                                     {\@twolinespacing}%
	                                     {\normalfont\normalsize\bfseries}}
\else
	\renewcommand\subsection{\@startsection {subsection}{2}{0pt}%
	                                     {\@twolinespacing}%
	                                     {\@tinyskip}%
	                                     {\normalfont\normalsize\bfseries}}
\fi

\ifwindows
	\renewcommand\subsubsection{\@startsection {subsubsection}{3}{0pt}%
	                                     {2\@twolinespacing}%
	                                     {\@twolinespacing}%
	                                     {\normalfont\normalsize\bfseries}}
\else
	\renewcommand\subsubsection{\@startsection {subsubsection}{3}{0pt}%
	                                     {\@twolinespacing}%
	                                     {\@tinyskip}%
	                                     {\normalfont\normalsize\bfseries}}
\fi

% [D8] 2-line spacing between last-line of text & table/figure/illustration
% --------------------------------------------------------------------
% From documentation in epslatex (by Keith Reckdahl):
%   \floatsep     - spacing between floats at top/bottom of page
%   \textfloatsep - spacing between text and the float at top/bottom of page
%   \intextsep    - spacing above & below the float in the middle of page

% The removed 20% extra spacing is added back, thus 1 / 0.8 = 1.25
\setlength{\floatsep}{1.25\@twolinespacing}
\setlength{\textfloatsep}{1.25\@twolinespacing plus 5pt}
\setlength{\intextsep}{1.25\@twolinespacing}

% ========================================
%             [P5] Title Page
% ----------------------------------------
% +++++++++++++++++++++
% Externalized string  - Title Page
% +++++++++++++++++++++
% -- English
\newcommand{\awardphrase@degree@en}               	{A final year project report submitted in partial fulfilment of the}
\newcommand{\awardphrase@mastercourse@en}         	{A project report submitted in partial fulfilment of the}
\newcommand{\awardphrase@mastercourseresearch@en} 	{A dissertation submitted in partial fulfilment of the}
\newcommand{\awardphrase@masterresearch@en}       	{A thesis submitted in fulfilment of the}
\newcommand{\awardphrase@phd@en}                  	{A thesis submitted in fulfilment of the}
\newcommand{\awardphrase@otherphd@en}             	{A dissertation submitted in partial fulfilment of the}
\newcommand{\awardphrase@genericphd@en}           	{A thesis submitted in fulfilment of the}
\newcommand{\awardphrase@proposal@en}             	{A proposal submitted in fulfilment of the}
\newcommand{\@awardphrasetwo@en}                  	{requirements for the award of the degree of}
\newcommand{\@awardphrasetwodegree@en}            	{requirements for the award of the degree of}
\newcommand{\@awardphrasethree@en}                	{requirements for the First Stage Examination of the degree of}
% -- Malay
\newcommand{\awardphrase@degree@ms}               	{Laporan projek tahun akhir ini dikemukakan sebagai memenuhi}
\newcommand{\awardphrase@mastercourse@ms}         	{Laporan projek ini dikemukakan sebagai memenuhi sebahagian daripada}
\newcommand{\awardphrase@mastercourseresearch@ms} 	{Disertasi ini dikemukakan sebagai memenuhi sebahagian daripada}
\newcommand{\awardphrase@masterresearch@ms}       	{Tesis ini dikemukakan sebagai memenuhi}
\newcommand{\awardphrase@phd@ms}                  	{Tesis ini dikemukakan sebagai memenuhi}
\newcommand{\awardphrase@otherphd@ms}             	{Disertasi ini dikemukakan sebagai memenuhi sebahagian daripada}
\newcommand{\awardphrase@genericphd@ms}           	{Tesis ini dikemukakan sebagai memenuhi}
\newcommand{\awardphrase@proposal@ms}             	{Cadangan ini dikemukakan sebagai memenuhi}
\newcommand{\@awardphrasetwo@ms}                  	{syarat penganugerahan ijazah}
\newcommand{\@awardphrasetwodegree@ms}            	{sebahagian daripada syarat penganugerahan ijazah}
\newcommand{\@awardphrasethree@ms}                	{syarat Peperiksaan Tahap Pertama penganugerahan ijazah}
% --
\newcommand{\awardphrase@degree}              		{\getstring{awardphrase@degree}}
\newcommand{\awardphrase@mastercourse}        		{\getstring{awardphrase@mastercourse}}
\newcommand{\awardphrase@mastercourseresearch}		{\getstring{awardphrase@mastercourseresearch}}
\newcommand{\awardphrase@masterresearch}      		{\getstring{awardphrase@masterresearch}}
\newcommand{\awardphrase@phd}                 		{\getstring{awardphrase@phd}}
\newcommand{\awardphrase@otherphd}            		{\getstring{awardphrase@otherphd}}
\newcommand{\awardphrase@genericphd}          		{\getstring{awardphrase@genericphd}}
\newcommand{\awardphrase@proposal}            		{\getstring{awardphrase@proposal}}
\newcommand{\@awardphrasetwo}                 		{\getstring{@awardphrasetwo}}
\newcommand{\@awardphrasethree}               		{\getstring{@awardphrasethree}}
\newcommand{\@awardphrasetwodegree}           		{\getstring{@awardphrasetwodegree}}

% -- English
\newcommand{\degreetype@degree@en}               	{final year project report}
\newcommand{\degreetype@mastercourse@en}         	{project report}
\newcommand{\degreetype@mastercourseresearch@en} 	{dissertation}
\newcommand{\degreetype@masterresearch@en}       	{thesis}
\newcommand{\degreetype@phd@en}                  	{thesis}
\newcommand{\degreetype@otherphd@en}             	{dissertation}
\newcommand{\degreetype@genericphd@en}           	{thesis}
\newcommand{\degreetype@proposal@en}             	{proposal}
% -- Malay
\newcommand{\degreetype@degree@ms}               	{laporan projek tahun akhir}
\newcommand{\degreetype@mastercourse@ms}         	{laporan projek}
\newcommand{\degreetype@mastercourseresearch@ms} 	{disertasi}
\newcommand{\degreetype@masterresearch@ms}       	{tesis}
\newcommand{\degreetype@phd@ms}                  	{tesis}
\newcommand{\degreetype@otherphd@ms}             	{disertasi}
\newcommand{\degreetype@genericphd@ms}           	{tesis}
\newcommand{\degreetype@proposal@ms}             	{cadangan}
% --
\newcommand{\degreetype@degree}              		{\getstring{degreetype@degree}}
\newcommand{\degreetype@mastercourse}        		{\getstring{degreetype@mastercourse}}
\newcommand{\degreetype@mastercourseresearch}		{\getstring{degreetype@mastercourseresearch}}
\newcommand{\degreetype@masterresearch}      		{\getstring{degreetype@masterresearch}}
\newcommand{\degreetype@phd}                 		{\getstring{degreetype@phd}}
\newcommand{\degreetype@otherphd}            		{\getstring{degreetype@otherphd}}
\newcommand{\degreetype@genericphd}          		{\getstring{degreetype@genericphd}}
\newcommand{\degreetype@proposal}            		{\getstring{degreetype@proposal}}

\renewcommand{\maketitle}{
  \ifnum \@award=1
    \def\@awardphrase{\awardphrase@degree}
    \def\@degreetype{\degreetype@degree}
  \fi
  \ifnum \@award=2
    \def\@awardphrase{\awardphrase@mastercourse}
    \def\@degreetype{\degreetype@mastercourse}
  \fi
  \ifnum \@award=3
    \def\@awardphrase{\awardphrase@mastercourseresearch}
    \def\@degreetype{\degreetype@mastercourseresearch}
  \fi
  \ifnum \@award=4
    \def\@awardphrase{\awardphrase@masterresearch}
    \def\@degreetype{\degreetype@masterresearch}
  \fi
  \ifnum \@award=5
    \def\@awardphrase{\awardphrase@phd}
    \def\@degreetype{\degreetype@phd}
  \fi
  \ifnum \@award=6
    \def\@awardphrase{\awardphrase@otherphd}
    \def\@degreetype{\degreetype@otherphd}
  \fi
  \ifnum \@award=7
    \def\@awardphrase{\awardphrase@genericphd}
    \def\@degreetype{\degreetype@genericphd}
  \fi
  \ifnum \@award=8
    \def\@awardphrase{\awardphrase@proposal}
    \def\@degreetype{\degreetype@proposal}
  \fi

% start drawing title page
  \if@openright\cleardoublepage\else\clearpage\fi
  \phantomsection
  \pdfbookmark[1]{TITLE PAGE}{pre:titlepage}
  \begin{center}
    %\null\vspace{0.4in}
    \ifx\@titlefour\@empty
    	\ifx\@titlethree\@empty
            \ifx\@titletwo\@empty
                \MakeUppercase{\@title}\\ 
            \else
                \MakeUppercase{\@title} \\
                \MakeUppercase{\@titletwo}\\ 
            \fi
        \else
    	    \MakeUppercase{\@title} \\
            \MakeUppercase{\@titletwo} \\
            \MakeUppercase{\@titlethree}\\ 
        \fi
    \else
	\MakeUppercase{\@title} \\
        \MakeUppercase{\@titletwo} \\
        \MakeUppercase{\@titlethree}\\ 
        \MakeUppercase{\@titlefour}\\ 
    \fi
    \vspace{\stretch{2}}
    \MakeUppercase{\@author}\\
    \vspace{\stretch{2}}
    \@awardphrase\\
   	\ifnum \@award=1
    		\@awardphrasetwodegree\\
    \else
    	    \ifnum \@award=8
 		   \@awardphrasethree\\
 		\else
           \@awardphrasetwo\\
    		\fi
    \fi

    \ifnum \@award=1
    		\@degree\space(\@specialization)\\
    	\else
    		\ifnum \@award=2
    			\@degree\space(\@specialization)\\
    		\else
    			\ifnum \@award=7
    				\@degree\\
    			\else
    				\ifnum \@award=8
    					\@degree\space(\@specialization)\\
    				\else
    					\ifnum \@intakeyear<2015
    						\@degree\space(\@specialization)\\
    					\else
    						\@degree\\
    					\fi
    				\fi
    			\fi
    		\fi
    	\fi

    \vspace{\stretch{1}}
    \ifx\@school\@empty 
    	\relax
    \else
        \@school\\
    \fi     
    \@faculty\\
    Universiti Teknologi Malaysia\\
    % changed to 2 to follow the manual
    \vspace{\stretch{2}}
    \expandafter\MakeUppercase{\@titledate}
  \end{center}
  \@hidepagenumber
}

% -----------------
% Preliminary Pages
% -----------------
% Define an empty, do-nothing \phantomsection.
% It will be over-written by 'hyperref' package.



% +++++++++++++++++++++
% Externalized string  - TOC, List of Tables/Figures/Appendices
% +++++++++++++++++++++
% -- English
\newcommand{\chapter@colname@en}    {Chapter}
\newcommand{\tablenum@colname@en}   {Table No.}
\newcommand{\figurenum@colname@en}  {Figure No.}
\newcommand{\appendixnum@colname@en}{Appendix}
\newcommand{\algorithmnum@colname@en}{Algo. No.}
\newcommand{\toctitle@colname@en}   {Title}
\newcommand{\title@colname@en}      {Title}
\newcommand{\page@colname@en}       {Page}
% -- Malay
\newcommand{\chapter@colname@ms}    {Bab}
\newcommand{\tablenum@colname@ms}   {No. Jadual}
\newcommand{\figurenum@colname@ms}  {No. Rajah}
\newcommand{\appendixnum@colname@ms}{Lampiran}
\newcommand{\algorithmnum@colname@ms}{No. Algo.}
\newcommand{\toctitle@colname@ms}   {Perkara}
\newcommand{\title@colname@ms}      {Tajuk}
\newcommand{\page@colname@ms}       {Halaman}
% --
\newcommand{\chapter@colname}     {\getstring{chapter@colname}}
\newcommand{\tablenum@colname}    {\getstring{tablenum@colname}}
\newcommand{\figurenum@colname}   {\getstring{figurenum@colname}}
\newcommand{\appendixnum@colname} {\getstring{appendixnum@colname}}
\newcommand{\algorithmnum@colname}{\getstring{algorithmnum@colname}}
\newcommand{\title@colname}       {\getstring{title@colname}}
\newcommand{\toctitle@colname}    {\getstring{toctitle@colname}}
\newcommand{\page@colname}        {\getstring{page@colname}}


% ========================================
%       [P11] Table of Contents
% ----------------------------------------

% Copied from book.cls:
%   \tableofcontents  - to generate 'Table of Contents' page
\renewcommand{\tableofcontents}{%
  \clearpage
  \phantomsection 
  \section*{\centering\contentsname}
  \vspace{23pt}
  \label{pre:tableofcontents}
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\contentsname}}  
  \@showpagenumber
 
  \begingroup 
    \begin{center}
      \bfseries\MakeUppercase{%
        \hspace{3em}\hfill%
        \toctitle@colname\hfill%
        \page@colname}
      \linebreak
    \end{center}
  \endgroup   
  \setstretch{1.435}
  \vspace{-17pt}
  \@starttoc{toc}
}


% ========================================
%       [P12] List of Tables
% ----------------------------------------
% Copied from book.cls:
%   \listoftables  - to generate 'List of Tables' page
\renewcommand{\listoftables}{
  \clearpage
  \phantomsection 
  \section*{\centering\listtablename}
  \vspace{23pt}

  \label{pre:listoftables}
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\listtablename}} 
  \@showpagenumber

  \begingroup
    \setlength{\parindent}{0pt}
    \begin{center}
      \bfseries\MakeUppercase{%
        \tablenum@colname\hfill%
        \title@colname\hfill\hspace{2.5em}%
        \page@colname}
      \linebreak
    \end{center}
  \endgroup
  \setstretch{1.435}
  \vspace{-17pt}
  \@starttoc{lot}
}

% ========================================
%         [P13] List of Figures
% ----------------------------------------
% Copied from book.cls:
%   \listoffigures  - to generate 'List of Figures' page
\renewcommand{\listoffigures}{
  \clearpage
  \phantomsection 
  \section*{\centering\listfigurename}
  \label{pre:listoffigures}
  \vspace{23pt}
  
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\listfigurename}} 
  \@showpagenumber

  \begingroup
    \setlength{\parindent}{0pt}
    \begin{center}
      \bfseries\MakeUppercase{%
        \figurenum@colname\hfill%
        \title@colname\hfill\hspace{3em}%
        \page@colname}
      \linebreak
    \end{center}  
  \endgroup
  \setstretch{1.435}
  \vspace{-17pt}
  \@starttoc{lof}
}


% Optional support for 'acronym' package to generate
% List of Symbols, and List of Abbreviation.
%
% User may choose to use the existing \addabbre and \addsymbol
% commands to generate the list, or, may switch to 'acronym'
% package by adding \usepackage{acronym} in preamble.
%
\AtBeginDocument{
  \@ifpackageloaded{acronym}{
    \newlength{\minlabelwidth}% 
    \renewcommand*{\aclabelfont}[1]{\textrm{\acsfont{#1}}}
    % Customize label format
    \def\bflabel#1{\textrm{#1}\hfill --}
    % Set minimal label width
    \setlength{\minlabelwidth}{.2\textwidth}%
    % Set fixed blank width after label
    \setlength{\labelsep}{2em}%

    % Copied from acronym.sty
    \renewenvironment{AC@deflist}[1]%
    {\ifAC@nolist%
       \else%
         \raggedright\begin{list}{}%
           {\settowidth{\labelwidth}{\textrm{#1} --}% based on \bflabel
            \ifdim \labelwidth <\minlabelwidth% enforce min label width
              \setlength{\labelwidth}{\minlabelwidth}%
            \fi
            \setlength{\leftmargin}{\labelwidth}%
            \addtolength{\leftmargin}{\labelsep}%
            \renewcommand{\makelabel}{\bflabel}}%
       \fi}%
    {\ifAC@nolist%
     \else%
       \end{list}%
     \fi}
  }{}
}

% ========================================
%       [P13] List of Symbols
% ----------------------------------------
%  Adapted from losymbol.sty by Gerry Van Dooren
\newcommand\listofsymbols{
  \clearpage
  \phantomsection
  \section*{\centering\listsymbolname}
  \label{pre:listofsymbols}
  \vspace{1.5cm}
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\listsymbolname}} 
  \@showpagenumber
  \setstretch{1.435}
  \@starttoc{los}
}

% New user command:
% ==============---------------------------------------------------============
%   \addsymbol - add an entry to \listofsymbols
%                e.g. \addsymbol{Symbol}{description}
% ==============---------------------------------------------------============
\newcommand{\addsymbol}[2]{%
\addtocontents{los}{\protect\makesymboltable{#1}{#2}}%
}

\newdimen\@lmsymbol %width of left margin column
\@lmsymbol=0.6em

\newdimen\@lcsymbol %width of left column
\@lcsymbol=8em

\newdimen\@rcsymbol %width of right column
\@rcsymbol=\textwidth

\newdimen\@scsymbol %width of space column
\@scsymbol=3em

\newdimen\@pcsymbol %width of page number column
\@pcsymbol=0em

\advance\@rcsymbol by -\@lmsymbol %subtract lmsymbol
\advance\@rcsymbol by -\@lcsymbol %subtract lcsymbol
\advance\@rcsymbol by -\@scsymbol %subtract space
\advance\@rcsymbol by -\@pcsymbol %subtract page number

\def\makesymboltable#1#2{%
\noindent\vspace{-0.3\baselineskip}\begin{minipage}[t]{\@lcsymbol}
\hspace{\@lmsymbol}#1
\end{minipage}
\begin{minipage}[t]{\@pcsymbol}-\end{minipage}
$\hspace{\@scsymbol}$
\begin{minipage}[t]{\@rcsymbol}#2\end{minipage}
}

% ========================================
%       [P14] List of Abbreviations
% ----------------------------------------
%  Adapted from losymbol.sty by Gerry Van Dooren
\newcommand\listofabbre{
  \clearpage
  \phantomsection 
  \section*{\centering\listabbrename}
  \label{pre:listofabbre}
  \vspace{1.5cm}
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\listabbrename}} 
  \@showpagenumber
  \setstretch{1.435}
  \@starttoc{loabbre}
}

% New user command:
% ==============---------------------------------------------------============
%   \addabbre - add an entry to \listofabbre
%                e.g. \addabbre{XML}{Extensible Markup Language}
% ==============---------------------------------------------------============
\newcommand{\addabbre}[2]{
  \addtocontents{loabbre}{\protect \makeabbretable{#1}{#2}}
}
\newdimen\@lmabbre %width of left margin column
\@lmabbre=0.6em
\newdimen\@lcabbre %width of left column
\@lcabbre=8em
\newdimen\@rcabbre %width of right column
\@rcabbre=\textwidth
\newdimen\@scabbre %width of space column
\@scabbre=3em
\newdimen\@pcabbre %width of page number column
\@pcabbre=0em
\advance\@rcabbre by -\@lmabbre %subtract lmabbre
\advance\@rcabbre by -\@lcabbre %subtract lcabbre
\advance\@rcabbre by -\@scabbre %subtract space
\advance\@rcabbre by -\@pcabbre %subtract page number

\def\makeabbretable#1#2{%
\noindent\vspace{-0.3\baselineskip}\begin{minipage}[t]{\@lcabbre}
\hspace{\@lmabbre}#1
\end{minipage}
\begin{minipage}[t]{\@pcabbre}-\end{minipage}
$\hspace{\@scabbre}$
\begin{minipage}[t]{\@rcabbre}#2\end{minipage}
}


% ========================================
%       [P15] List of Appendices
% ----------------------------------------
\newcommand{\listofappendices}{
  \clearpage
  \section*{\centering\listappendixname}
  \phantomsection 
  \label{pre:listofappendices}
  \vspace{23pt}
  \setstretch{1.435} 
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\listappendixname}} 
  \@showpagenumber

  \begingroup
    \setlength{\parindent}{0pt}
    \begin{center}
      \bfseries\MakeUppercase{%
        \appendixnum@colname\hfill%
        \title@colname\hfill\hspace{2.5em}%
        \page@colname}
      \linebreak
    \end{center}  
  \endgroup
  \setstretch{1.435}
  \vspace{-17pt}
  \@starttoc{loapp}
}

% ========================================
%       [P16] List of Algorithms (optional)
% ----------------------------------------
\renewcommand{\listofalgorithms}{
  \clearpage
  \section*{\centering\listalgorithmname}
  \label{pre:listofalgorithm}
  \vspace{23pt}
  \setstretch{1.435} 
  \addcontentsline{toc}{chapter}{\hspace{\toc@tab@a}\MakeUppercase{\listalgorithmname}} 
  \@showpagenumber

  \begingroup
    \setlength{\parindent}{0pt}
	\begin{flushleft}
		\bfseries\MakeUppercase{\algorithmnum@colname}\vspace*{-1.07\toc@tab@jumps}
    \end{flushleft}
    \begin{center}
		\bfseries\MakeUppercase{\title@colname}\vspace*{-1.03\toc@tab@jumps}
    \end{center}
    \begin{flushright}
		\bfseries\MakeUppercase{\page@colname}
		\linebreak
    \end{flushright}
  \endgroup
  \setstretch{1.435}
  \@starttoc{loa}
}

% ========================================
%           [P17] References
% ----------------------------------------
% Custom heading section for References page
\newcommand\utmthesis@bibheading{
  \if@openright\cleardoublepage\@hidepagenumber\else\clearpage\@hidepagenumber\fi 
  \phantomsection

  \chapter*{\bibname}%
  \@showpagenumber
  \label{pre:references}
  \addtocontents{toc}{\protect\addvspace{\@twolinespacing}}
  \addcontentsline{toc}{chapter}{\protect\MakeUppercase{\bibname}}
}

% Copied from book.cls:
%   thebibliography environment
\renewenvironment{thebibliography}[1]
     {\utmthesis@bibheading
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m%
    }
    {\def\@noitemerr
     {\@latex@warning{Empty `thebibliography' environment}}%
     \endlist}

\AtBeginDocument{
  % As natbib package redefines \thebibliography environemnt,
  % when it is loaded,we need to inject the custom heading section back into it
  % through natbib's \bibsection.
  %
  \@ifpackageloaded{natbib}{
    \renewcommand\bibsection{\utmthesis@bibheading}
  }{}
}

% For bibliography default (number) scheme, each bibliography item is
% numbered with "#n." where #n is 1, 2, 3 and so on.
\renewcommand\@biblabel[1]{#1.}

% ========================================
%          [P18] Appendices
% ----------------------------------------
% Copied from book.cls:
% \appendix  - to indicate the start of appendix section
  \renewcommand{\appendix}{%
  \renewcommand{\theHchapter}{A\arabic{chapter}}
  \@appendixtrue
  \settocdepth{chapter}
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}
  \phantomsection
  %\addtocontents{toc}{\protect\vspace{\@twolinespacing}}
  %\addtocontents{toc}{\protect\noindent\MakeUppercase{\bf\appendicesname}}
  %\addtocontents{toc}{\protect\addvspace{\@twolinespacing}}%
}

% Needed for correct ToC, LoF, LoT
\def\endmatter{
	\@appendixtoctrue
    \settocdepth{subsection}
    \phantomsection 
}

%making box to align section head left indent
\makeatletter
\def\@seccntformat#1{\protect\makebox[0.5in][l]{\csname
the#1\endcsname\quad}}
\makeatother
\setstretch{1.435}

%% Default plain pagestyle to make all page numbers be at bottom centre 
\pagestyle{plain}
