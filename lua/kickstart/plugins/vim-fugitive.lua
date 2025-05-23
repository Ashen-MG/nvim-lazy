return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', ':G<cr><c-w>K')

    local VimFugtive = vim.api.nvim_create_augroup('VimFugtive', {})

    local autocmd = vim.api.nvim_create_autocmd

    autocmd('BufWinEnter', {
      group = VimFugtive,
      pattern = '*',
      callback = function()
        if vim.bo.ft ~= 'fugitive' then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set('n', '<leader>p', function()
          vim.cmd.Git 'push'
        end, opts)

        vim.keymap.set('n', '<leader>P', function()
          vim.cmd.Git { 'stash' }
          vim.cmd.Git { 'pull --rebase' }
          vim.cmd.Git { 'stash pop' }
          vim.cmd.Git { 'submodule update' } -- checkout submodules
        end, opts)

        vim.keymap.set('n', '<leader>s', function()
          vim.cmd.Git { 'submodule update' } -- checkout submodules
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set('n', '<leader>t', ':Git push -u origin ', opts)
      end,
    })

    vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>')
    vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>')
  end,
}
