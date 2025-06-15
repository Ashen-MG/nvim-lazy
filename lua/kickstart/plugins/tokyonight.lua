return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = true,
        day_brightness = 0.5,
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        on_highlights = function(hl)
          -- See https://lospec.com/palette-list/tokyo-night
          -- Default seems to be #565f89
          hl.comment = { fg = '#737aa2' }
          hl.perlComment = { fg = '#737aa2' }
          hl.Comment = { fg = '#737aa2' }
          -- hl.IlluminatedWordText = { bg = "#ffffff", fg = "#ffffff" }
        end,
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
