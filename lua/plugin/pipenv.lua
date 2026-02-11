---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/pipenv.nvim',
  dev = true,
  version = false,
  config = function()
    require('pipenv').setup({
      output = {
        float = true,
        split = 'above',
        border = 'rounded',
        height = 0.75,
        width = 0.85,
      },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = {
        ['<leader>P'] = { group = '+Pipenv' },
        ['<leader>Pp'] = { group = '+Run UI' },
        ['<leader>P<CR>'] = { ':Pipenv ', desc('Prompt', false) },
        ['<leader>PC'] = { ':Pipenv! clean<CR>', desc('Clean (Verbose)') },
        ['<leader>PI'] = { ':Pipenv! install ', desc('Prompt To Install (Verbose)', false) },
        ['<leader>PL'] = { ':Pipenv! lock<CR>', desc('Lock (Verbose)') },
        ['<leader>PR'] = { ':Pipenv requirements<CR>', desc('Requirements') },
        ['<leader>PS'] = { ':Pipenv! sync ', desc('Prompt To Sync (Verbose)', false) },
        ['<leader>PU'] = { ':Pipenv! uninstall ', desc('Prompt To Uninstall (Verbose)', false) },
        ['<leader>PV'] = { ':Pipenv! verify<CR>', desc('Verify (Verbose)') },
        ['<leader>Pc'] = { ':Pipenv clean<CR>', desc('Clean') },
        ['<leader>Pe'] = { ':Pipenv edit<CR>', desc('Edit Pipfile') },
        ['<leader>Pg'] = { ':Pipenv graph<CR>', desc('Graph') },
        ['<leader>Pi'] = { ':Pipenv install ', desc('Prompt To Install', false) },
        ['<leader>Pl'] = { ':Pipenv lock<CR>', desc('Lock') },
        ['<leader>Po'] = { ':Pipenv list-installed<CR>', desc('List Installed') },
        ['<leader>PpD'] = { ':Pipenv! dev=true<CR>', desc('Verbose and `dev=true`') },
        ['<leader>Ppd'] = { ':Pipenv dev=true<CR>', desc('`dev=true`') },
        ['<leader>Ppp'] = { ':Pipenv<CR>', desc('No Flags') },
        ['<leader>Ppv'] = { ':Pipenv!<CR>', desc('Verbose') },
        ['<leader>Pr'] = { ':Pipenv run ', desc('Prompt To Run', false) },
        ['<leader>Ps'] = { ':Pipenv! sync ', desc('Prompt To Sync', false) },
        ['<leader>Pu'] = { ':Pipenv uninstall ', desc('Prompt To Uninstall', false) },
        ['<leader>Pv'] = { ':Pipenv verify<CR>', desc('Verify') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
