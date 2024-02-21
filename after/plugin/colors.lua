function ColorMyPencils(color)
    -- color = color or 'kanagawa-dragon'
    color = color or 'nordfox'
    vim.cmd.colorscheme(color)

    -- If you do not want the transparent window effect remove these
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

