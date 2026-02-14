---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/pipenv.nvim',
  dev = true,
  version = false,
  dependencies = { 'wsdjeg/job.nvim', 'wsdjeg/picker.nvim', 'xieyonn/spinner.nvim' },
  config = function()
    require('pipenv').setup({
      output = {
        float = true,
        split = 'above',
        border = 'rounded',
        height = 0.75,
        width = 0.85,
      },
      spinner = { enabled = true, opts = { hl_group = 'Number', kind = 'cursor' } },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = {
        ['<leader>P'] = { group = '+Pipenv' },
        ['<leader>Pd'] = { group = 'dev = true' },
        ['<leader>Pdp'] = { group = 'pre = true' },
        ['<leader>Pm'] = { group = '+Run UI' },
        ['<leader>Pp'] = { group = 'pre = true' },
        ['<leader>Ppd'] = { group = 'dev = true' },
        ['<leader>P<CR>'] = { ':Pipenv ', desc('Prompt', false) },
        ['<leader>PC'] = { ':Pipenv! clean<CR>', desc('Clean (Verbose)') },
        ['<leader>PI'] = { ':Pipenv! install ', desc('Prompt To Install (Verbose)', false) },
        ['<leader>PL'] = { ':Pipenv! lock<CR>', desc('Lock (Verbose)') },
        ['<leader>PP'] = { ':Pipenv<CR>', desc('No Flags') },
        ['<leader>PR'] = { ':Pipenv requirements<CR>', desc('Requirements') },
        ['<leader>PS'] = { ':Pipenv! sync ', desc('Prompt To Sync (Verbose)', false) },
        ['<leader>PU'] = { ':Pipenv! uninstall ', desc('Prompt To Uninstall (Verbose)', false) },
        ['<leader>PV'] = { ':Pipenv! verify<CR>', desc('Verify (Verbose)') },
        ['<leader>Pc'] = { ':Pipenv clean<CR>', desc('Clean') },
        ['<leader>PdI'] = { ':Pipenv! install dev=true ', desc('Prompt Install (Verbose)', false) },
        ['<leader>PdP'] = { ':Pipenv! dev=true<CR>', desc('Verbose Menu') },
        ['<leader>PdR'] = { ':Pipenv requirements dev=true<CR>', desc('Requirements') },
        ['<leader>PdS'] = { ':Pipenv! sync dev=true ', desc('Prompt To Sync (Verbose)', false) },
        ['<leader>PdU'] = {
          ':Pipenv! uninstall dev=true ',
          desc('Prompt To Uninstall (Verbose)', false),
        },
        ['<leader>Pdi'] = { ':Pipenv install dev=true ', desc('Prompt To Install', false) },
        ['<leader>Pdl'] = { ':Pipenv lock dev=true<CR>', desc('Lock') },
        ['<leader>PdpI'] = {
          ':Pipenv! install dev=true pre=true ',
          desc('Prompt Install (Verbose)', false),
        },
        ['<leader>PdpP'] = { ':Pipenv! dev=true pre=true<CR>', desc('Verbose Menu') },
        ['<leader>PdpS'] = {
          ':Pipenv! sync dev=true pre=true ',
          desc('Prompt To Sync (Verbose)', false),
        },
        ['<leader>PdpU'] = {
          ':Pipenv! uninstall dev=true pre=true ',
          desc('Prompt To Uninstall (Verbose)', false),
        },
        ['<leader>Pdpi'] = {
          ':Pipenv install pre=true dev=true ',
          desc('Prompt To Install', false),
        },
        ['<leader>Pdpl'] = { ':Pipenv lock dev=true pre=true<CR>', desc('Lock') },
        ['<leader>Pdps'] = { ':Pipenv! sync dev=true pre=true ', desc('Prompt To Sync', false) },
        ['<leader>Pdpu'] = {
          ':Pipenv uninstall dev=true pre=true ',
          desc('Prompt To Uninstall', false),
        },
        ['<leader>Pds'] = { ':Pipenv! sync dev=true ', desc('Prompt To Sync', false) },
        ['<leader>Pdu'] = { ':Pipenv uninstall dev=true ', desc('Prompt To Uninstall', false) },
        ['<leader>Pe'] = { ':Pipenv edit<CR>', desc('Edit Pipfile') },
        ['<leader>Pg'] = { ':Pipenv graph<CR>', desc('Graph') },
        ['<leader>Pi'] = { ':Pipenv install ', desc('Prompt To Install', false) },
        ['<leader>Pl'] = { ':Pipenv lock<CR>', desc('Lock') },
        ['<leader>Po'] = { ':Pipenv list-installed<CR>', desc('List Installed') },
        ['<leader>PpI'] = { ':Pipenv! install pre=true ', desc('Prompt Install (Verbose)', false) },
        ['<leader>PpP'] = { ':Pipenv! pre=true<CR>', desc('Verbose') },
        ['<leader>PpS'] = { ':Pipenv! sync pre=true ', desc('Prompt To Sync (Verbose)', false) },
        ['<leader>PpU'] = {
          ':Pipenv! uninstall pre=true ',
          desc('Prompt To Uninstall (Verbose)', false),
        },
        ['<leader>PpdI'] = {
          ':Pipenv! install pre=true dev=true ',
          desc('Prompt Install (Verbose)', false),
        },
        ['<leader>PpdP'] = { ':Pipenv! pre=true dev=true<CR>', desc('Verbose Menu') },
        ['<leader>PpdS'] = {
          ':Pipenv! sync pre=true dev=true ',
          desc('Prompt To Sync (Verbose)', false),
        },
        ['<leader>PpdU'] = {
          ':Pipenv! uninstall pre=true dev=true ',
          desc('Prompt To Uninstall (Verbose)', false),
        },
        ['<leader>Ppdi'] = {
          ':Pipenv install dev=true pre=true ',
          desc('Prompt To Install', false),
        },
        ['<leader>Ppdl'] = { ':Pipenv lock pre=true dev=true<CR>', desc('Lock') },
        ['<leader>Ppds'] = { ':Pipenv! sync pre=true dev=true ', desc('Prompt To Sync', false) },
        ['<leader>Ppdu'] = {
          ':Pipenv uninstall pre=true dev=true ',
          desc('Prompt To Uninstall', false),
        },
        ['<leader>Ppi'] = { ':Pipenv install pre=true ', desc('Prompt To Install', false) },
        ['<leader>Ppl'] = { ':Pipenv lock pre=true<CR>', desc('Lock') },
        ['<leader>Pps'] = { ':Pipenv! sync pre=true ', desc('Prompt To Sync', false) },
        ['<leader>Ppu'] = { ':Pipenv uninstall pre=true ', desc('Prompt To Uninstall', false) },
        ['<leader>Pr'] = { ':Pipenv run ', desc('Prompt To Run', false) },
        ['<leader>Ps'] = { ':Pipenv! sync ', desc('Prompt To Sync', false) },
        ['<leader>Pu'] = { ':Pipenv uninstall ', desc('Prompt To Uninstall', false) },
        ['<leader>Pv'] = { ':Pipenv verify<CR>', desc('Verify') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
