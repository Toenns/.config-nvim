local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep  -- zum Spiegeln von Insert-Nodes (falls benötigt)
local cond = require("luasnip.extras.conditions.expand")


-- Hilfsfunktionen analog zu Deinen globalen Funktionen in UltiSnip

local function in_mathzone()
  -- Prüft, ob wir uns in einem Math-Zone befinden.
  -- Achte darauf, dass vimtex in Lua evtl. Zahlen statt Strings zurückgibt.
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local function in_comment()
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end

local function in_env(name)
  local res = vim.fn["vimtex#env#is_inside"](name)
  -- res ist ein Array mit zwei Werten; beide ungleich '0' bedeutet, dass wir in der Umgebung sind.
  return res[1] ~= '0' and res[2] ~= '0'
end

-- Basis-Snippets für TeX
 local tex_snippets = {

  -- Package import
  s({ trig = "pac",
      name = "usepackage",
   }, {
    t("\\usepackage["),
    i(1, "options"), -- Default options
    t("]{"),
    i(2, "package"), -- Package name
    t({ "}", "", }),
    i(0),
  }),

  -- Basic template
  s({trig = "template",
     condition = cond.line_begin -- ergibt nur fuer autosnippets Sinn.
    }, {
    t({
      "\\documentclass[a4paper]{article}",
      "\\usepackage[latin1]{inputenc}",
      "\\usepackage[T1]{fontenc}",
      "\\usepackage{textcomp}",
      "\\usepackage{amsmath, amssymb}",
      "\\usepackage[ngerman]{babel}",
      "\\usepackage{amsmath, amssymb, amsthm}",
      "\\usepackage{bbm}",
      "\\usepackage{kpfonts}",
      "% figure support",
      "\\usepackage{import}",
      "\\usepackage{xifthen}",
      "\\pdfminorversion=7",
      "\\usepackage{pdfpages}",
      "\\usepackage{transparent}",
      "\\newcommand{\\incfig}[1]{%",
      "\\def\\svgwidth{\\columnwidth}",
      "\\import{./figures/}{#1.pdf_tex}",
      "}",
      "\\pdfsuppresswarningpagegroup=1",
      "\\begin{document}",
      "",
    }),
    i(1),  -- Placeholder for user input
    t({"", "\\end{document}"}),
  }),

-------------------- environments --------------------

    -- Begin / End environment
    s({ trig = "beg",
        snippetType = "autosnippet", -- autoexpand
        name = "begin",              -- will be shown in the drop down menu
        condition = cond.line_begin
      }, {
      t({"\\begin{"}),
      i(1),
      t({"}", ""}),
      i(2),
      t({ "", "\\end{"}),
      rep(1),
      t({"}", ""}),
      i(0),
    }),

  -- Table environment
  s("table", {
    t("\\begin{table}["),
    i(1), -- Default placement
    t({ "]", "\\centering", "\\caption{", }),
    i(2, "caption"), -- Default caption
    t({ "}", "\\label{tab:", }),
    i(3, "label"),
    t({ "}", "\\begin{tabular}{", }),
    i(4, "c"), -- Default column format
    t({ "}", "", }),
    i(5), -- Placeholder for table contents
    t({ "", "\\end{tabular}", "\\end{table}", })
  }),

  -- Figure environment
  s({ trig = "fig",
      name = "figure environment",
  }, {
    t("\\begin{figure}["),
    i(1, "htpb"), -- Default placement
    t("]\n\\centering\n\\includegraphics[width=0.8\\textwidth]{"),
    i(2, "image"), -- Placeholder for image filename
    t("}\n\\caption{"),
    i(3, "caption"), -- Default caption
    t("}\n\\label{fig:"),
    i(4, "fig_label"), -- Default label
    t("}\n\\end{figure}\n")
  }),

  -- Enumerate
  s({ trig = "enum",
      name = "Enumerate",
      snippetType = "autosnippet",
      condition = cond.line_begin,
    },{
    t({ "\\begin{enumerate}", "", "\\item", }),
    i(1),
    t({ "", "\\end{enumerate}", "", }),
    i(0)
  }),

  -- Itemize
  s({ trig = "item",
      name = "Itemize",
      snippetType = "autosnippet",
      condition = cond.line_begin,
  }, {
    t({ "\\begin{itemize}", "\\item", }),
    i(1),
    t({ "", "\\end{itemize}", "", }),
    i(0)
  }),

  -- Description
  s("desc", {
    t({ "\\begin{description}", "\\item[", }),
    i(1, "Term"), -- Placeholder for term
    t("]"),
    i(2), -- Placeholder for definition
    t({ "", "\\end{description}", }),
    i(0),
  }),

  -- Math mode
  s({ trig = "mk",
      name = "inline math",
      snippetType = "autosnippet",
  }, {
    t( "\\(" ),
    i(1), -- Math content
    t( "\\)" ),
    i(0),
  }),

  -- Display math
  s({ trig = "dm",
      name = "display math",
      snippetType = "autosnippet",
  }, {
      t({ "\\[", "", }),
      i(1),
      t({ "", ".\\]", "", }),
      i(0),
  }),

  -- Align environment
  s({ trig = "ali",
      name = "Align",
      condition = cond.line_begin,
      snippetType = "autosnippet",
  }, {
    t({ "\\begin{align*}", "", }),
    i(1),
    t({ "", "\\end{align*}", "", }),
    i(0),
  }),


-------------------- math environment --------------------

  -- text in math mode
  s({ trig = "tt",
      name = "text",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\text{"),
      i(1),
      t("}"),
      i(0),
  }),

  -- cases
  s({ trig = "case",
      name = "Cases",
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t({"\\begin{cases}"}),
        i(1),
      t({"\\end{cases}"}),
      i(0),
  }),


-------------------- logic operators --------------------

  -- logic and
  s({ trig = "and",
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\land")
  }),

  -- logic or
  s({ trig = "or",
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\lor")
  }),

  -- implies
  s({ trig = "=>",
      name = "implies",
      snippetType = "autosnippet",
      wordTrig = false,
  }, {
      t("\\implies"),
  }),

  -- implied by
  s({ trig = "=<",
      name = "impliedby",
      snippetType = "autosnippet",
      wordTrig = false,
  }, {
      t("\\impliedby"),
  }),

  -- iff
  s({ trig = "iff",
      snippetType = "autosnippet",
      wordTrig = false,
      condition = in_mathzone,
  }, {
      t("\\iff"),
  }),

  -- negation
  s({ trig = "negg",
      name = "negation",
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\neg"),
  }),

-------------------- rounding --------------------

  s({ trig = "ceil",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\left\\lceil"),
      i(1),
      t("\\right\\rceil"),
      i(0),
  }),

  s({ trig = "floor",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\left\\lfloor"),
      i(1),
      t("\\right\\rfloor"),
      i(0),
  }),

-------------------- matrices and arrays--------------------

  -- Parenthesis Matrix
  s({ trig = "pmat",
      name = "parenthesis matrix",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t({ "\\begin{pmatrix}", "", }),
    i(1), -- Placeholder for matrix content
    t({ "", "\\end{pmatrix}", }),
    i(0),
  }),

  -- Braced Matrix
  s({ trig = "bmat",
      name = "braced matrix",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t({ "\\begin{bmatrix}", "", }),
    i(1), -- Placeholder for matrix content
    t({ "", "\\end{bmatrix}", }),
    i(0),
  }),

-------------------- braces --------------------

  -- left( right)
  s({ trig = "()",
      name = "leftright()",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\left("),
      i(1),
      t("\\right)"),
      i(0),
  }),

  -- left( right)
  s({ trig = "lr",
      name = "leftright()",
      wordTrig = false,
  }, {
      t("\\left("),
      i(1),
      t("\\right)"),
      i(0)
  }),

  -- left| right|
  s({ trig = "lr|",
      name = "leftright||",
      wordTrig = false,
  }, {
      t("\\left|"),
      i(1),
      t("\\right|)"),
      i(0)
  }),

  -- left{ right}
  s({ trig = "lrb",
      name = "leftright{}",
      wordTrig = false,
  }, {
      t("\\left\\{"),
      i(1),
      t("\\right\\}"),
      i(0)
  }),

  -- left[ right]
  s({ trig = "lr[",
      name = "leftright[]",
      wordTrig = false,
  }, {
      t("\\left["),
      i(1),
      t("\\right]"),
      i(0)
  }),

  -- leftangle rightangle
  s({ trig = "lra",
      name = "leftrightangle",
      snippetType = "autosnippet",
      wordTrig = false,
  }, {
      t("\\left<"),
      i(1),
      t("\\right>"),
      i(0)
  }),

----------------------------------------

  -- conjugate
  s({ trig = "conj",
      name = "conjugate",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\overline{"),
      i(1),
      t("}"),
      i(0),
  }),

  -- sum
  s({ trig = "sum",
  }, {
      t("\\sum_{k="),
      i(1, "1"),
      t("}^{"),
      i(2, "\\infty"),
      t("}"),
      i(3, "a_k z^k"),
      i(0),
  }),

  -- taylor
  -- s({ trig = "taylor",
  -- }, {
  --     t("\\sum_{"),
  --     i(1, "k"),
  --     t("="),
  --     i(2, "1"),
  --     t("}^{"),
  --     i(3, "\\infty"),
  --     t("}")
  --     })
  -- }),

  -- limes
  s({ trig = "lim",
  }, {
      t("\\lim_{"),
      i(1, "n"),
      t("\\to"),
      i(2, "\\infty"),
      t("}"),
      i(0),
  }),

  -- limes inferior
  s({ trig = "liminf",
  }, {
      t("\\liminf_{"),
      i(1, "n"),
      t("\\to"),
      i(2, "\\infty"),
      t("}"),
      i(0),
  }),

  -- limes superior
  s({ trig = "limsup",
  }, {
      t("\\limsup_{"),
      i(1, "n"),
      t("\\to"),
      i(2, "\\infty"),
      t("}"),
      i(0),
  }),

  -- product
  s({ trig = "prod",
      name = "product",
  }, {
      t("\\prod_{"),
      i(1, "n"),
      t("="),
      i(2, "1"),
      t("}^{"),
      i(3, "\\infty"),
      t("}"),
      i(4),
  }),

  -- partial derivative
  s({ trig = "part",
      name = "part deriv",
  }, {
      t("\\frac{\\partial"),
      i(1, "V"),
      t("}{\\partial"),
      i(2, "x"),
      t("}"),
      i(0),
  }),

  -- integral
  s({ trig = "dint",
      name = "Integral",
      snippetType = "autosnippet",
  }, {
    t("\\int_{"),
    i(1),
    i(1, "-\\infty"), -- Default lower limit
    t("}^{"),
    i(2, "\\infty"), -- Default upper limit
    t("} "),
    i(3, "f(x)"), -- Default function
  }),

-------------------- powers and roots --------------------

  -- square root
  s({ trig = "sq",
      name = "sqrt",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\sqrt{"),
          i(1),
      t("}"),
  }),

  -- square power
  s({ trig = "sr",
      name = "^2",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("^2"),
  }),

  -- cubic power
  s({ trig = "cb",
      name = "^3",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("^3"),
  }),

  -- Power (Exponentiation)
  s({ trig = "td",
      name = "Exponentiation",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("^{"),
    i(1), -- Placeholder for exponent
    t("}"),
    i(0),
  }),

  -- Power in braces
  s({ trig = "rd",
      name = "power in braces",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("^{("),
    i(1),
    t(")}"),
    i(0),
  }),

  -- inverse
  s({ trig = "invs",
      name = "Inverse",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("^{-1}"),
  }),


-------------------- indices --------------------

  -- Subscript
  s({ trig = "__",
      name = "subscript",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
      t("_{"),
      i(1),
      t("}"),
      i(0),
  }),

-------------------- symbols --------------------

  -- Infinity symbol
  s({ trig = "ooo",
      name = "Infinity",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\infty")
  }),

  -- low dots
  s({ trig = "...",
      snippetType = "autosnippet",
      wordTrig = false,
      priority = 100,
    }, {
      t("\\ldots"),
  }),


-------------------- arrows --------------------

  -- to
  s({ trig = "->",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
      priority = 100,
    }, {
      t("\\to"),
  }),

  -- leftrightarrow
  s({ trig = "<->",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
      priority = 200,
    }, {
      t("\\leftrightarrow"),
  }),

  -- Rightarrow
  -- s({ trig = "=>",
  --     wordTrig = false,
  --     snippetType = "autosnippet",
  --     condition = in_mathzone,
  --     priority = 100,
  --   }, {
  --     t("\\Rightarrow"),
  -- }),

  -- Leftrightarrow (equivalent)
  s({ trig = "eqq",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
      priority = 200,
    }, {
      t("\\Leftrightarrow"),
  }),

  -- maps to
  s({ trig = "!>",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
    }, {
      t("\\mapsto"),
  }),

-------------------- relational operators --------------------

  -- Less equal
  s({ trig = "<=",
      name = "less_equal",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\le")
  }),

  -- less less
  s({ trig = "<<",
      name = "less_less",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\ll")
  }),

  -- greater equal
  s({ trig = ">=",
      name = "greater_equal",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\ge")
  }),

  -- greater greater
  s({ trig = ">>",
      name = "greater_greater",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\gg")
  }),

  -- Equals
  s({ trig = "==",
      name = "equals",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("&= "),
    i(1),
    t(" \\\\")
  }),

  -- not equal
  s({ trig = "!=",
      name = "not equal",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\neq")
  }),

  -- Equivalent
  s({ trig = "===",
  }, {
    t("\\equiv"),
  }),


----------------------------------------
  -- mrij ??? ultisnip checken was das ist
  --

-------------------- operators --------------------

  -- Fraction
  s({ trig = "//",
      name = "fraction",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\frac{"),
    i(1), -- Numerator
    t("}{"),
    i(2), -- Denominator
    t({ "}", }),
    i(0),
  }),

  -- times
  s({ trig = "xx",
      name = "Times",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\times"),
  }),

  -- cdot
  s({ trig = "**",
      name = "cdot",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\cdot"),
  }),

  -- Norm
  s({ trig = "norm",
      name = "Norm",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\|"),
    i(1), -- Placeholder for expression
    t("\\|"),
    i(0),
  }),

  -- nabla
  s({ trig = "nabl",
      name = "Nabla",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\nabla"),
  }),


----------------- sinus etc. ultisnip -> line 450




-------------------- set symbols and special letters --------------------

  -- Mathematical Caligraphic
  s({ trig = "mcal",
      name = "Caligraphic",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
   }, {
    t("\\mathcal{"),
    i(1), -- Placeholder for symbol
    t("}")
  }),

  -- empty set
  s({ trig = "OO",
      name = "empty set",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
      t("\\emptyset"),
  }),

  -- Number set symbols
  s({ trig = "NN",
      name = "N",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{N}")
  }),

  -- Number set symbols
  s({ trig = "ZZ",
      name = "Z",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{Z}")
  }),

  -- Number set symbols
  s({ trig = "QQ",
      name = "Q",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{Q}")
  }),

  -- real numbers
  s({ trig = "RR",
      name = "R",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{R}")
  }),

  -- positive real numbers
  s({ trig = "R0+",
      name = "R0+",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\mathbbm{R}_0^+")
  }),

  -- complex numbers
  s({ trig = "CC",
      name = "C",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{C}")
  }),

  -- Koerper
  s({ trig = "KK",
      name = "K",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{K}")
  }),

  -- field
  s({ trig = "FF",
      name = "F",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\mathbbm{F}")
  }),


------------------ set operators ----------------------

  -- cap
  s({ trig = "nnn",
      name = "cap",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
    t("\\cap")
  }),

  -- cup
  s({ trig = "uuu",
      name = "cup",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
      t("\\cup"),
  }),

  -- big cap
  s({ trig = "Nn",
      name = "big cap",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
      t("\\bigcap_{"),
      i(1, "i"),
      t("\\in"),
      i(2, "I"),
      t("}"),
      i(0),
  }),

  -- big cup
  s({ trig = "UU",
      name = "big cup",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
      t("\\bigcup_{"),
      i(1, "i"),
      t("\\in"),
      i(2, "I"),
      t("}"),
      i(0),
  }),

  -- in
  s({ trig = "inn",
      name = "in",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\in"),
  }),

  -- not in
  s({ trig = "notin",
      name = "not in",
      wordTrig = false,
      snippetType = "autosnippet",
  }, {
      t("\\not\\in"),
  }),

  -- subset
  s({ trig = "cc",
      name = "sub set",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\subset"),
  }),

  -- subset equal
  s({ trig = "cce",
      name = "sub set equal",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\subseteq"),
  }),

  -- complement
  s({ trig = "compl",
      name = "complement",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("^{c}"),
  }),

  -- set minus
  s({ trig = "\\\\\\",
      name = "complement",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
      t("\\setminus"),
  }),

  -- exists
  s({ trig = "EE",
      name = "Exists",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\exists")
  }),

  -- exists no ...
  s({ trig = "nEE",
      name = "exists no",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\nexists")
  }),

  -- exists exact one
  s({ trig = "EE!",
      name = "Exists one",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\exists!")
  }),

  -- for all
  s({ trig = "AA",
      name = "For all",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("\\forall")
  }),


-------------------- python --------------------

  -- Function node example (for complex calculations, etc.)
  s("sympy", {
    t("sympy "),
    i(1), -- Placeholder for sympy expression
    t(" sympy")
  }),


  -- Sympy block
  s("sympyblock", {
    t("sympy "),
    i(1), -- Placeholder for sympy code
    t(" sympy")
  }),


-------------------- trigonometric funtions --------------------



------------------- indexed variables ---------------------

  -- x_{n}
  s({ trig = "xnn",
      name = "x_n",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("x_{n}")
  }),

  -- y_{n}
  s({ trig = "ynn",
      name = "y_n",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("y_{n}")
  }),

  -- x_{i}
  s({ trig = "xii",
      name = "x_i",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("x_{i}")
  }),

  -- y_{i}
  s({ trig = "yii",
      name = "y_i",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("y_{i}")
  }),

  -- x_{j}
  s({ trig = "xjj",
      name = "x_j",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("x_{j}")
  }),

  -- y_{j}
  s({ trig = "yjj",
      name = "y_j",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("y_{j}")
  }),

  -- x_{n+1}
  s({ trig = "xp1",
      name = "x_(n+1)",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("x_{n+1}")
  }),

  -- x_{m}
  s({ trig = "xmm",
      name = "x_m",
      wordTrig = false,
      snippetType = "autosnippet",
      condition = in_mathzone,
  }, {
    t("x_{m}")
  }),

}

-- Register the snippets for TeX files
return tex_snippets


