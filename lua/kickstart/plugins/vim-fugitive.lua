return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', ':G<cr><c-w>K')

    local VimFugtive = vim.api.nvim_create_augroup('VimFugtive', {})

    local autocmd = vim.api.nvim_create_autocmd

    local function getBranchName()
      local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
      -- local branch = vim.cmd.Git({'rev-parse --abbrev-ref HEAD'}); -- does not return anything
      if branch ~= '' then
        return branch
      else
        return ''
      end
    end

    local function getSubmoduleBranchName()
      local branch = vim.fn.system "git submodule foreach 'git status' | sed -n '2 p' | cut -d ' ' -f 3"
      if branch ~= '' then
        return branch
      else
        return ''
      end
    end

    local function checkout(branchName)
      vim.cmd.Git { 'fetch origin ' .. branchName }
      -- vim.cmd.Git({'checkout --recurse-submodules '..branchName})
      vim.cmd.Git { 'checkout ' .. branchName }
      -- vim.cmd.Git({'pull --recurse-submodules'}) -- checkout submodules
      vim.cmd.Git { 'pull' }
      vim.cmd.Git { 'submodule update' } -- checkout submodules
    end

    local function commit(branch, opts)
      local prefix = branch:find('/', 0)
      if prefix == nil then
        prefix = 0
      else
        prefix = prefix + 1
      end
      local taskName = nil
      local i = branch:find('-', prefix)
      if i ~= nil then
        i = branch:find('-', i + 1)
        taskName = branch:sub(prefix, i - 1)
      end

      if taskName == nil then
        print 'Invalid branch name'
        vim.cmd.Git { 'commit -m "' .. opts.args .. '"' }
      else
        vim.cmd.Git { 'commit -m "' .. taskName .. ':' .. ' ' .. opts.args .. '"' }
      end
    end

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

    vim.api.nvim_create_user_command('Gco', function(opts)
      local branch = getBranchName()
      commit(branch, opts)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('Gcos', function(opts)
      local branch = getSubmoduleBranchName()
      commit(branch, opts)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('Gch', function(opts)
      checkout(opts.args)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('Gchs', function(opts)
      vim.cmd.Git { 'stash' }
      checkout(opts.args)
      vim.cmd.Git { 'stash pop' }
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('Uncommit', function()
      vim.cmd.Git { 'reset --soft HEAD^' }
    end, { nargs = 0 })

    vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>')
    vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>')
  end,
}
