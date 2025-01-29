local M = {
  'SirVer/ultisnips',  -- Das UltiSnips-Plugin für Snippet-Verwaltung.
  ft = { "tex", "bib" },  -- Das Plugin wird nur für LaTeX-Dateien aktiviert.
}

M.config = function()
  vim.g.UltiSnipsExpandTrigger = "<tab>"  -- Aktiviert das Snippet-Expanding durch Drücken von <tab>.
  vim.g.UltiSnipsJumpForwardTrigger = "<tab>"  -- Springt zum nächsten Snippet-Placeholder mit <tab>.
  vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"  -- Springt zum vorherigen Snippet-Placeholder mit <shift-tab>.
end

return M
