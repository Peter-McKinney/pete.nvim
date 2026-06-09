-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  -- Keymaps live in lua/custom/keymaps.lua under the "[[ dap / debug ]]" section.
  -- Lazy.nvim intercepts `require('dap')` / `require('dapui')` and loads this plugin
  -- on first use, so no `keys = {}` trigger is needed here.
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'js-debug-adapter',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Node.js / TypeScript / NestJS debugging via vscode-js-debug (installed by mason)
    local js_debug_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter'

    -- Locate a Chrome/Chromium binary for pwa-chrome launch configs.
    -- pwa-chrome's default search only checks PATH, which usually misses macOS app bundles.
    local function find_chrome()
      local candidates = {
        '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
      }
      for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 then
          return path
        end
      end
      for _, name in ipairs { 'google-chrome', 'chromium', 'chrome' } do
        if vim.fn.executable(name) == 1 then
          return name
        end
      end
      return nil
    end
    local chrome_bin = find_chrome()

    for _, adapter in ipairs { 'pwa-node', 'pwa-chrome', 'node-terminal' } do
      dap.adapters[adapter] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug_path .. '/js-debug/src/dapDebugServer.js', '${port}' },
        },
      }
    end

    dap.set_log_level 'TRACE'

    -- Map legacy "node" type onto pwa-node so launch.json files still work
    dap.adapters.node = function(cb, config)
      if config.type == 'node' then
        config.type = 'pwa-node'
      end
      local native = dap.adapters['pwa-node']
      if type(native) == 'function' then
        native(cb, config)
      else
        cb(native)
      end
    end

    for _, lang in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
      dap.configurations[lang] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'NestJS: npm run start:debug',
          runtimeExecutable = 'npm',
          runtimeArgs = { 'run', 'start:debug' },
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach: NestJS --inspect 9229',
          address = 'localhost',
          port = 9229,
          localRoot = '${workspaceFolder}',
          remoteRoot = '${workspaceFolder}',
          sourceMaps = true,
          restart = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach: pick process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch current file (ts-node)',
          runtimeExecutable = 'node',
          runtimeArgs = { '--loader=ts-node/esm' },
          args = { '${file}' },
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Jest: debug current file',
          runtimeExecutable = 'node',
          runtimeArgs = {
            '--inspect-brk',
            '${workspaceFolder}/node_modules/.bin/jest',
            '--runInBand',
            '--no-coverage',
            '${file}',
          },
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**', '**/node_modules/**' },
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          -- Requires `ng serve` to already be running on :4200
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Angular: Launch Chrome @ localhost:4200',
          url = 'http://localhost:4200',
          webRoot = '${workspaceFolder}',
          runtimeExecutable = chrome_bin,
          sourceMaps = true,
          userDataDir = vim.fn.stdpath 'cache' .. '/dap-chrome',
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*',
            ['webpack:///./~/*'] = '${webRoot}/node_modules/*',
          },
          skipFiles = { '<node_internals>/**', 'node_modules/**', '**/webpack/**' },
        },
        {
          -- Attach to a Chrome started with `--remote-debugging-port=9222`
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Angular: Attach to Chrome :9222',
          port = 9222,
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*',
            ['webpack:///./~/*'] = '${webRoot}/node_modules/*',
          },
          skipFiles = { '<node_internals>/**', 'node_modules/**', '**/webpack/**' },
        },
      }
    end
  end,
}
