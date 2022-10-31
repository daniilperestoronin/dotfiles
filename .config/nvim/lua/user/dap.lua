local dap = require('dap')

vim.fn.sign_define('DapBreakpoint',
                   {text = '', texthl = '', linehl = '', numhl = ''})

-- Setup DAP for Go
dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
        stdio = {nil, stdout},
        args = {"dap", "-l", "127.0.0.1:" .. port},
        detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        handle:close()
        if code ~= 0 then print('dlv exited with code', code) end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function() require('dap.repl').append(chunk) end)
        end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
        callback({type = "server", host = "127.0.0.1", port = port})
    end, 100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {type = "go", name = "Debug", request = "launch", program = "${file}"}, {
        type = "go",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
    }, -- works with go.mod packages and sub packages 
    {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}

-- Setup DAP for Python
require('dap-python').setup('python')

-- Setup DAP for JS
dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {'/usr/local/lib/node_modules/node-debug/bin/node-debug.js'}
}
dap.configurations.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal'
    }, {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require'dap.utils'.pick_process
    }
}

-- setup nvim-dap-ui
require('dapui').setup({
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40,
      position = 'right',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 10,
      position = 'bottom',
    },
  },
})
