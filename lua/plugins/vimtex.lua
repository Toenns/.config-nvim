local M = {
  'lervag/vimtex',               -- vimtex Plugin für LaTeX
  -- 'KeitaNakamura/tex-conceal.vim', -- tex-conceal Plugin für LaTeX
  ft = { "tex", "bib" },         -- Nur für LaTeX-Dateien aktivieren
}

M.config = function()
  -- vimtex Konfiguration
  vim.g.tex_flavor = 'latex'                -- LaTeX als TeX-Flavour verwenden
  vim.g.vimtex_view_method = 'zathura'      -- PDF-Viewer: Zathura
  vim.g.vimtex_quickfix_mode = 0            -- Quickfix-Mode deaktivieren
  vim.g.vimtex_compiler_method = 'lualatex' -- Compiler-Methode auf lualatex setzen
  vim.g.maplocalleader = ','                -- Setzt das lokale Leaderzeichen auf ','
  vim.g.tex_indent_items = 0               -- Indentation für LaTeX-Listen deaktivieren
  vim.g.vimtex_view_general_viewer = "zathura"
  vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
   -- vim.g.vimtex_view_general_options_latexmk = '-reuse-instance'

  -- tex-conceal Konfiguration
  vim.opt.conceallevel = 1                  -- Conceal-Level auf 1 setzen
  vim.g.tex_conceal = 'abdmg'               -- Verborgene LaTeX-Symbole (z.B. Section-Titel)
  vim.cmd [[hi Conceal ctermbg=none]]       -- Setzt die Hintergrundfarbe für "concealed" Text auf transparent

  -- Farbe der Concealed Zeichen auf Grün ändern
  vim.cmd [[
      highlight Conceal guifg=#00d56d ctermfg=Green
  ]]


end

return M

